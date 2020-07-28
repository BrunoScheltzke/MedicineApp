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
    let medicinesVC = RemindersViewController()
    
    init(window: UIWindow?, database: LocalDatabaseServiceProtocol) {
        self.database = database
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        self.window = window
    }
    
    func start() {
        guard let window = window else { return }
        
        let mecicinesVM = RemindersViewModel(database: database, delegate: self)
        database.listener = mecicinesVM
        medicinesVC.viewModel = mecicinesVM
        navigationController.viewControllers = [medicinesVC]
        
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
    }
}

extension AppCoordinator: RemindersViewModelDelegate {
    func didAskToAddReminder() {
        let createReminderCoordinator = CreateReminderCoordinator(presenter: navigationController, database: database)
        createReminderCoordinator.delegate = self
        createReminderCoordinator.start()
    }
}

extension AppCoordinator: CreateReminderDelegate {
    func finishCreatingReminder() {
        medicinesVC.reload()
    }
}
