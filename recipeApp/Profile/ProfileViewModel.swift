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
    
    func createUser() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "User", in: context) {
            let newUser = NSManagedObject(entity: entity, insertInto: context)
            newUser.setValue("TEST", forKey: "first_name")
            newUser.setValue("DUDE", forKey: "last_name")
            newUser.setValue("idk@gmail.com", forKey: "email")
            newUser.setValue("Chinese", forKey: "preferences")
            newUser.setValue("nuts", forKey: "dietary_restrictions")
            newUser.setValue([], forKey: "saved_recipes")
        }
    }
    
    func loadUser(data: NSManagedObject){
        let user = User()
        if let firstName = data.value(forKey: "first_name") as? String {
            user.first_name = firstName
        }
        if let lastName = data.value(forKey: "last_name") as? String {
            user.last_name = lastName
        }
        if let email = data.value(forKey: "email") as? String {
            user.email = email
        }
        if let dietaryRestrictions = data.value(forKey: "dietary_restrictions") as? String {
            user.dietary_restrictions = dietaryRestrictions
        }
        if let preferences = data.value(forKey: "preferences") as? String {
            user.preferences = preferences
        }
    }
    
    func saveUser(user: User){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "User", in: context) {
            
            let newUser = NSManagedObject(entity: entity, insertInto: context)
            if let firstName = user.first_name {
                newUser.setValue(firstName, forKey: "first_name")
            }
            if let lastName = user.last_name {
                newUser.setValue(lastName, forKey: "last_name")
            }
            if let email = user.email {
                newUser.setValue(email, forKey: "email")
            }
            if let dietaryRestrictions = user.dietary_restrictions {
                newUser.setValue(dietaryRestrictions, forKey: "dietary_restrictions")
            }
            if let preferences = user.preferences {
                newUser.setValue(preferences, forKey: "preferences")
            }
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
}
