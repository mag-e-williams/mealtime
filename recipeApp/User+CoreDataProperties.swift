//
//  User+CoreDataProperties.swift
//  recipeApp
//
//  Created by Kasdan on 12/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var dietary_restrictions: String?
    @NSManaged public var email: String?
    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var preferences: String?
    @NSManaged public var filters: String?
    @NSManaged public var favorites: Recipe?

}
