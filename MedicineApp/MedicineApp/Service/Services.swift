//
//  Services.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 08/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

protocol LocalDatabaseServiceProtocol {
    var watchListener: RegisterListener? { get set }
    var listener: RegisterListener? { get set }
    func fetchAllReminders() -> [Reminder]
    @discardableResult func createReminder(medicine: Medicine, date: Date, dosage: Dosage, frequency: [Frequency], quantity: Int32) -> Reminder
    @discardableResult func createMedicine(name: String, brand: String?, unit: Int32, dosage: Dosage) -> Medicine
    func fetchRegister(of reminder: Reminder, at date: Date) -> Register?
    @discardableResult func createRegister(for reminder: Reminder, date: Date, taken: Bool) -> Register?
    @discardableResult func complete(_ register: Register) -> Register
    func getRegister(of reminder: Reminder, at date: Date) -> Register
    func fetchReminder(byId id: String) -> Reminder?
    func fetchRegister(byId id: String) -> Register?
    func fetchTodayRegisters() -> [Register]
}

protocol RegisterListener {
    func updatedTodayRegisters(_ registers: [Register])
}

protocol NotificationServiceProtocol {
    @discardableResult func setup(_ reminder: Reminder) -> [String]
    func requestAuthorization(completion: @escaping(NotifiationResult) -> Void)
}

enum NotifiationResult {
    case error(Error)
    case granted(Bool)
}

protocol WatchDatabaseServiceProtocol {
    func fetchTodaysRegisters(completion: @escaping([Register]) -> Void)
    func complete(_ register: Register, completion: @escaping (Register) -> Void)
}
