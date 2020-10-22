//
//  SceneDelegate.swift
//  ShoppingList
//
//  Created by Tales Conrado on 14/10/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coreDataManager: CoreDataManager?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        coreDataManager = CoreDataManager()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let nav = UINavigationController(rootViewController: ListDetailController(dataManager: coreDataManager!))
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        coreDataManager!.saveContext()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        coreDataManager!.saveContext()
    }

}

