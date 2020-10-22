//
//  ListDetailController.swift
//  ShoppingList
//
//  Created by Tales Conrado on 14/10/20.
//

import UIKit
import CoreData

class ListDetailController: UIViewController, NSFetchedResultsControllerDelegate {
    
    let dataManager: CoreDataManager
    
    lazy var contentView: ListDetailView = {
        let view = ListDetailView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Item> = {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.dataManager.managedContext!, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    init(dataManager: CoreDataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        CustomAlerts().startLoadingAlert(presenter: self, with: "Carregando...")
        dataManager.loadContainer {
            self.dismiss(animated: true, completion: nil)
        }
        try? dataManager.persistentContainer?.viewContext.setQueryGenerationFrom(.current)
        addRefreshControl()
        fetchingResults()
        setupNavigationBar()
    }
    
    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshing), for: .valueChanged)
        contentView.tableView.refreshControl = refreshControl
    }
    
    @objc func refreshing(sender: UIRefreshControl) {
        fetchingResults()
        sender.endRefreshing()
    }
    
    func fetchingResults() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }

    override func loadView() {
        view = contentView
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Compras"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    }
    
    @objc func addItem() {
        promptForTitle()
    }
    
    func promptForTitle(item: Item? = nil) {
        let ac = UIAlertController(title: "Novo Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields![0].placeholder = "Nome"
        ac.addTextField()
        ac.textFields![1].placeholder = "Categoria"
        if let item = item {
            ac.textFields![0].text = item.name
            ac.textFields![1].text = item.category
        }

        let submitAction = UIAlertAction(title: "Confirmar", style: .default) { [unowned ac] _ in
            let title = ac.textFields![0]
            let category = ac.textFields![1]
            guard let titleText = title.text, let categoryText = category.text  else { return }
            if !titleText.isEmpty {
                if item == nil {
                    let item = Item(context: self.dataManager.managedContext!)
                    item.name = titleText
                    item.category = titleText
                } else {
                    item?.update(named: titleText, category: categoryText)
                }
            }
        }
        
        let dismissAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        ac.addAction(submitAction)
        ac.addAction(dismissAction)
        present(ac, animated: true)
    }
}

extension ListDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = fetchedResultsController.fetchedObjects else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = fetchedResultsController.object(at: indexPath)
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = item.name
        cell!.detailTextLabel?.text = item.category
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchedResultsController.object(at: indexPath)
            item.managedObjectContext?.delete(item)
            dataManager.saveContext()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        promptForTitle(item: item)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}

// MARK: NSFetchedResultsControllerDelegate

extension ListDetailController {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contentView.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contentView.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                contentView.tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                contentView.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                contentView.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            print("default")
        }
    }
}
