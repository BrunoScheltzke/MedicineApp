//
//  AppCoordinator.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 03/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import UIKit

protocol Coordinator {
    var rootViewController: UIViewController { get set }
    func start()
}

protocol NavigationCoordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: NavigationCoordinator {
    var navigationController: UINavigationController
    var window: UIWindow?
    var database: LocalDatabaseServiceProtocol!
    
    init(window: UIWindow?) {
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        self.window = window
    }
    
    func start() {
        guard let window = window else { return }
        
        let medicinesVC = RemindersViewController()
        let coredata = CoreDataService()
        database = coredata
        let mecicinesVM = RemindersViewModel(database: coredata, delegate: self)
        
        medicinesVC.viewModel = mecicinesVM
        navigationController.viewControllers = [medicinesVC]
        
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
    }
}

extension AppCoordinator: RemindersViewModelDelegate {
    func didAskToAddReminder() {
        let createReminderCoordinator = CreateReminderCoordinator(presenter: navigationController, database: database)
        createReminderCoordinator.start()
    }
}
