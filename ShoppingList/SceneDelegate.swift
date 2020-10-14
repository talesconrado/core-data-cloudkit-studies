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
        let nav = UINavigationController(rootViewController: ViewController(dataManager: coreDataManager!))
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        coreDataManager!.saveContext()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        coreDataManager!.saveContext()
    }

}

