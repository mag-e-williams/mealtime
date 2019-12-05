//
//  ProfileViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
//    var user: User?
//    var viewModel: ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                self.loadUser(data: data)
                print(data.value(forKey: "first_name") as! String)
            }
        } catch {
            print("Failed")
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
