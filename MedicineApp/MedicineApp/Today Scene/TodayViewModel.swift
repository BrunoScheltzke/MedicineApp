//
//  TodayViewModel.swift
//  MedicineApp
//
//  Created by VM on 28/07/20.
//  Copyright © 2020 Bruno Scheltzke. All rights reserved.
//

import Foundation

protocol TodayViewModelDelegate {
    func didGet(_ items: [Register])
    func failed(message: String)
}

class TodayViewModel {
    
    var delegate: TodayViewModelDelegate?
    
    private let database: LocalDatabaseServiceProtocol
    
    init(database: LocalDatabaseServiceProtocol = CoreDataService()) {
        self.database = database
    }
    
    func getTodayRegisters() {
        let registers = database.fetchTodayRegisters()
        delegate?.didGet(registers)
    }
    
}
