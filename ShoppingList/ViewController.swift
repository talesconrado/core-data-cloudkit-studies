//
//  ViewController.swift
//  ShoppingList
//
//  Created by Tales Conrado on 14/10/20.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    let dataManager: CoreDataManager
    
    lazy var contentView: View = {
        let view = View()
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
        fetchingResults()
        setupNavigationBar()
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
    
    func promptForTitle() {
        let ac = UIAlertController(title: "Digite o nome do item", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Confirmar", style: .default) { [unowned ac] _ in
            let title = ac.textFields![0]
            guard let text = title.text else { return }
            if !text.isEmpty {
                self.dataManager.createData(named: text)
            }
        }
        
        let dismissAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        ac.addAction(submitAction)
        ac.addAction(dismissAction)
        present(ac, animated: true)
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell!.detailTextLabel?.text = formatDate(date: item.createdAt!)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchedResultsController.object(at: indexPath)
            item.managedObjectContext?.delete(item)
        }
    }
}

// MARK: NSFetchedResultsControllerDelegate

extension ViewController {
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
        default:
            print("default")
        }
    }
}
