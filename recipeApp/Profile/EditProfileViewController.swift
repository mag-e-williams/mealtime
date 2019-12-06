//
//  EditProfileViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 12/5/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var dietaryRestrictions: UITextField!
    @IBOutlet weak var preferences: UITextField!
    
    
    func saveFields() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) {
            let newUser = NSManagedObject(entity: entity, insertInto: context)
            if let firstName = self.firstName.text {
                newUser.setValue(firstName, forKey: "first_name")
            }
            if let lastName = self.lastName.text {
                newUser.setValue(lastName, forKey: "last_name")
            }
            if let email = self.email.text {
                newUser.setValue(email, forKey: "email")
            }
            if let dietaryRestrictions = self.dietaryRestrictions.text {
                newUser.setValue(dietaryRestrictions, forKey: "dietary_restrictions")
            }
            if let preferences = self.preferences.text {
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
    
