//
//  ProfileViewModel.swift
//  recipeApp
//
//  Created by Kasdan on 12/5/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ProfileViewModel {
    
    func createUser(_ entity: String) -> NSManagedObject? {
        // Helpers
        var result: NSManagedObject?
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: context)
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: context)
        }
        return result
    }
    
    func fetchUser(_ entity: String) -> NSManagedObject? {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        // Helpers
        var result = NSManagedObject()

        do {
            // Execute Fetch Request
            let records = try context.fetch(fetchRequest)
            print(records)
            if let records = records as? [NSManagedObject?] {
                if records == [] {
                    return nil
                }
                result = records[0]!
                print(result)
                print(records)
                return records[0]
            }

        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
            return nil
        }

        return result
    }
    
    
    func resetData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.reset()
        UserDefaults.standard.set(false, forKey: "TermsAccepted")
    }
}
