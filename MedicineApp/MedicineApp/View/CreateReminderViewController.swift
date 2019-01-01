//
//  CreateReminderViewController.swift
//  PillApp
//
//  Created by Bruno Scheltzke on 04/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Eureka
import Intents

class CreateReminderViewController: FormViewController {
    let name = "name"
    let dosage = "dosage"
    let quantity = "quantity"
    let frequency = "frequency"
    let hour = "hour"
    
    var viewModel: CreateReminderViewModel!
    
    init(viewModel: CreateReminderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CreateReminderViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationButtons()
        setupForm()
    }
    
    func setupNavigationButtons() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leave))
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func leave() {
        viewModel.leave()
    }
    
    @objc func save() {
        let dict = form.values()
        
        guard let medicine = dict[name] as? String else {
            return
        }
        
        guard let dosageStr = dict[dosage] as? String,
            let dosage = Dosage.init(rawValue: dosageStr) else {
                return
        }
        
        guard let quantity = dict[quantity] as? Int else {
            return
        }
        
        guard let frequency = dict[frequency] as? Frequency else {
            return
        }
        
        guard let hour = dict[hour] as? Date else {
            return
        }
        
        let medicineModel = viewModel.database.createMedicine(name: medicine, brand: nil, unit: 50, dosage: dosage)
        viewModel.database.createReminder(medicine: medicineModel, date: hour, dosage: dosage, frequency: [frequency], quantity: Int32(quantity))
        
        setupSiriIntent()
        
        viewModel.leave()
    }
    
    func setupSiriIntent() {
        let identifier = "takeMedicine"
        
        let activity = NSUserActivity(activityType: identifier)
        activity.title = "Take today's medicine"
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = identifier
        self.userActivity = activity
        activity.becomeCurrent()
    }
    
    func setupForm() {
        form +++ Section("Medicine")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Enter the medicine name here"
                row.tag = name
            }
            <<< PushRow<String>() {
                $0.title = "Dosage"
                $0.selectorTitle = "Select the dosage"
                $0.options = Dosage.allCases.map { $0.rawValue }
                $0.value = Dosage.allCases.first!.rawValue
                $0.tag = dosage
            }
            <<< IntRow(){ row in
                row.title = "Quantity"
                row.placeholder = "Enter the quantity here"
                row.tag = quantity
            }
            +++ Section("Reminder")
            <<< PushRow<Frequency>() {
                $0.title = "Frequency"
                $0.selectorTitle = "Select the frequency"
                $0.options = Frequency.allCases
                $0.value = Frequency.allCases.first!
                $0.tag = frequency
            }
            <<< TimeRow(){
                $0.title = "Hour"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
                $0.tag = hour
        }
    }
}
