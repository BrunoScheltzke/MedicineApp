//
//  RemindersViewController.swift
//  PillApp
//
//  Created by Bruno Scheltzke on 03/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import UIKit

class RemindersViewController: UIViewController {
    var viewModel: RemindersViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reminderListDelegate = self
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateReminders()
        tableView.reloadData()
    }
    
    func setupNavigationBar() {
        let addReminderBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReminder))
        navigationItem.rightBarButtonItem = addReminderBarButton
        title = viewModel.title
    }
    
    func setupTableView() {
        tableView.register(type: ReminderItemTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func addReminder() {
        viewModel.addReminder()
    }
}

extension RemindersViewController: ReminderListDelegate {
    func updatedRemindersList() {
        tableView.reloadData()
    }
}

extension RemindersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Today"
        case 1: return "Tomorrow"
        default: return viewModel.sectionNames[section]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.reminderCellVMsByDate.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reminderCellVMsByDate[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderItemTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ReminderItemTableViewCell
            else { return UITableViewCell() }
        
        cell.viewModel = viewModel.reminderCellVMsByDate[indexPath.section][indexPath.row]
        
        return cell
    }
}

extension RemindersViewController: UITableViewDelegate {
    
}
