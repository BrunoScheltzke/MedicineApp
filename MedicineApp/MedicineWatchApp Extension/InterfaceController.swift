//
//  InterfaceController.swift
//  MedicineWatchApp Extension
//
//  Created by Bruno Scheltzke on 08/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        fetchDataSource()
    }
    
    func fetchDataSource() {
        iOSManager.shared.getDailyReminders({ registers in
            self.setupTable(with: registers)
        }) { error in
            print(error)
        }
    }
    
    func setupTable(with registers: [Register]) {
        self.tableView.setNumberOfRows(registers.count, withRowType: "RegisterCell")
        
        for index in 0..<self.tableView.numberOfRows {
            guard let controller = self.tableView.rowController(at: index) as? RegisterCell else { continue }
            controller.delegate = self
            controller.register = registers[index]
        }
    }
    
    override func willActivate() {
        super.willActivate()
        fetchDataSource()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: CellDelegate {
    func askedToTakeMedicine(for register: Register) {
        iOSManager.shared.tookMedicineFor(register)
    }
}

extension InterfaceController: RegisterListener {
    func updatedTodayRegisters(_ registers: [Register]) {
        setupTable(with: registers)
    }
}
