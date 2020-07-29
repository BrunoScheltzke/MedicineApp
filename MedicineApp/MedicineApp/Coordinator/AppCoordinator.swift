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
    func start()
}

class AppCoordinator: NavigationCoordinator {
    var window: UIWindow?
    var database: LocalDatabaseServiceProtocol!
    let medicinesVC = RemindersViewController()
    let tabBarController = UITabBarController()
    
    init(window: UIWindow?, database: LocalDatabaseServiceProtocol) {
        self.database = database
        self.window = window
    }
    
    func start() {
        guard let window = window else { return }
        
        let todayViewModel = TodayViewModel()
        let todayViewController = TodayViewController(viewModel: todayViewModel)
        let todayNav = UINavigationController()
        todayNav.viewControllers = [todayViewController]
        todayNav.tabBarItem.title = "Today"
        tabBarController.addChild(todayNav)
        
        let mecicinesVM = RemindersViewModel(database: database, delegate: self)
        database.listener = mecicinesVM
        medicinesVC.viewModel = mecicinesVM
        let remindersNav = UINavigationController()
        remindersNav.navigationBar.prefersLargeTitles = true
        remindersNav.viewControllers = [medicinesVC]
        remindersNav.tabBarItem.title = "Week"
        tabBarController.addChild(remindersNav)
        
        window.makeKeyAndVisible()
        window.rootViewController = tabBarController
    }
    
}

extension AppCoordinator: RemindersViewModelDelegate {
    func didAskToAddReminder() {
        let createReminderCoordinator = CreateReminderCoordinator(presenter: medicinesVC, database: database)
        createReminderCoordinator.delegate = self
        createReminderCoordinator.start()
    }
}

extension AppCoordinator: CreateReminderDelegate {
    func finishCreatingReminder() {
        medicinesVC.reload()
    }
}
