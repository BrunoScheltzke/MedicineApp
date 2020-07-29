//
//  TodayViewController.swift
//  MedicineApp
//
//  Created by VM on 28/07/20.
//  Copyright © 2020 Bruno Scheltzke. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    let viewModel: TodayViewModel
    
    let tableView = UITableView()
    var items: [Register] = []
    
    init(viewModel: TodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TodayViewController", bundle: Bundle.main)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.constraintFully(to: view)
        tableView.register(type: ReminderItemTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.getTodayRegisters()
    }

}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReminderItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = ReminderCellViewModel(register: items[indexPath.row], database: CoreDataService())
        return cell
    }
    
}

extension TodayViewController: TodayViewModelDelegate {
    func didGet(_ items: [Register]) {
        self.items = items
        tableView.reloadData()
    }
    
    func failed(message: String) {
        present(message: message)
    }
}
