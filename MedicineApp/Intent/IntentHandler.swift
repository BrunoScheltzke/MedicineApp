//
//  IntentHandler.swift
//  Intent
//
//  Created by Bruno Scheltzke on 28/11/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    let database = Database()
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

extension IntentHandler: TakeMedicineIntentHandling {
    func handle(intent: TakeMedicineIntent,
                completion: @escaping (TakeMedicineIntentResponse) -> Void) {
        
        // get the medicine Id from the intent
        guard let medicineId = intent.medicine?.identifier,
              let medicine = database.getMedicine(byId: medicineId) else {
                
            //in case it is an invalid id, just return a generic error message
            let response = TakeMedicineIntentResponse(code: .failureRequiringAppLaunch,
                                                      userActivity: nil)
            completion(response)
            return
        }
        
        // check if the medicine should be taken today
        guard medicine.shouldTakeToday else {
           
            if let nextMedicine = database.upNextMedicine() {
                
                let response = TakeMedicineIntentResponse
                    .failureNext(medicine: medicine.name,
                    nextMedicine: nextMedicine.name,
                    date: nextMedicine.nextDate)
                
                completion(response)
                return
                
            } else {
                let response = TakeMedicineIntentResponse(code: .failureRequiringAppLaunch,
                                                          userActivity: nil)
                completion(response)
                return
            }
        }
        
        // valid medicine, check it as taken
        database.checkMedicineAsTaken(medicine)
        
        let response = TakeMedicineIntentResponse
            .successMessage(medicine: medicine.name,
                            date: medicine.nextDate)
        completion(response)
    }
}

class Database {
    func getMedicine(byId id: String) -> Medicine? {
        return Medicine(name: "Camomile tea", shouldTakeToday: false, nextDate: "tomorrow")
    }
    
    func checkMedicineAsTaken(_ medicine: Medicine) {
        
    }
    
    func upNextMedicine() -> Medicine? {
        return Medicine(name: "Paracetamol", shouldTakeToday: false, nextDate: "today 9PM")
    }
}

struct Medicine {
    var name: String
    var shouldTakeToday: Bool
    var nextDate: String
}
