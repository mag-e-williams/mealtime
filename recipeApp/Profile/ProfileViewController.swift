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
    
    var user: User?
    var viewModel = ProfileViewModel()
    
    @IBOutlet var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                viewModel.loadUser(data: data)
                print(data.value(forKey: "first_name") as! String)
            }
        } catch {
            print("Failed")
        }
    }
    
}
