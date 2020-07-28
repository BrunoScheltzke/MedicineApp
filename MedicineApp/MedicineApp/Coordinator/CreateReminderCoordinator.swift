//
//  CreateReminderCoordinator.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 04/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import UIKit

protocol CreateReminderDelegate {
    func finishCreatingReminder()
}

class CreateReminderCoordinator: NavigationCoordinator {
    internal var navigationController: UINavigationController
    private var presenter: UIViewController
    private var database: LocalDatabaseServiceProtocol
    var delegate: CreateReminderDelegate?
    
    init(presenter: UIViewController, database: LocalDatabaseServiceProtocol) {
        navigationController = UINavigationController()
        self.presenter = presenter
        self.database = database
    }
    
    func start() {
        let createReminderVM = CreateReminderViewModel(delegate: self, database: database)
        let createReminderVC = CreateReminderViewController(viewModel: createReminderVM)
        navigationController.viewControllers = [createReminderVC]
        presenter.present(navigationController, animated: true, completion: nil)
    }
}

extension CreateReminderCoordinator: CreateReminderViewModelProtocol {
    func didAskToDismiss() {
        delegate?.finishCreatingReminder()
        navigationController.dismiss(animated: true, completion: nil)
    }
}
