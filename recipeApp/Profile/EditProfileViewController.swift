//
//  EditProfileViewController.swift
//  mealtime
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
  
    @IBOutlet weak var cancelButton: UIButton!
    
    let viewModel = ProfileViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.delegate = self
        let user = viewModel.fetchUser("User")
        if user?.value(forKey: "first_name") == nil || user?.value(forKey: "first_name") as? String == "" {
            firstName.placeholder = "First Name Placeholder"
        }
        else {
            firstName.text = user?.value(forKey: "first_name") as? String
        }
        if user?.value(forKey: "last_name") == nil || user?.value(forKey: "last_name") as? String == "" {
            lastName.placeholder = "Last Name Placeholder"
        }
        else {
            lastName.text = user?.value(forKey: "last_name") as? String
        }
        if user?.value(forKey: "email") == nil || user?.value(forKey: "email") as? String == "" {
            email.placeholder = "Email Placeholder"
        }
        else {
            email.text = user?.value(forKey: "email") as? String
        }
        if user?.value(forKey: "preferences") == nil || user?.value(forKey: "preferences") as? String == "" {
            preferences.placeholder = "Cuisines Placeholder"
        }
        else {
            preferences.text = user?.value(forKey: "preferences") as? String
        }
        if user?.value(forKey: "dietary_restrictions") == nil || user?.value(forKey: "dietary_restrictions") as? String == "" {
            dietaryRestrictions.placeholder = "Dietary Restrictions Placeholder"
        }
        else {
            dietaryRestrictions.text = user?.value(forKey: "dietary_restrictions") as? String
        }
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func close() {
        performSegueToReturnBack()
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
    
extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
