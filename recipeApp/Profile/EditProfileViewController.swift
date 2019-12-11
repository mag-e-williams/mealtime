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
    
    let viewModel = ProfileViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func saveFields() {
        let user : NSManagedObject?
        print("saveFields called")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        user = viewModel.fetchUser("User")
        
        if let firstName = self.firstName.text {
            print(firstName)
            user?.setValue(firstName, forKey: "first_name")
//            print(user?.value(forKey: "first_name")!)
        }
        if let lastName = self.lastName.text {
            print(lastName)
            user?.setValue(lastName, forKey: "last_name")
        }
        if let email = self.email.text {
            print(email)
            user?.setValue(email, forKey: "email")
        }
        if let preferences = self.preferences.text {
            print(preferences)
            user?.setValue(preferences, forKey: "preferences")
        }
        if let dietaryRestrictions = self.dietaryRestrictions.text {
            print(dietaryRestrictions)
            user?.setValue(dietaryRestrictions, forKey: "dietary_restrictions")
        }
        
        do {
            try context.save()
            print("context was saved")
        } catch {
            print("Failed saving")
        }
    }
}
    
