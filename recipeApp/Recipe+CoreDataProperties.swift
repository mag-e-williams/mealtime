//
//  Recipe+CoreDataProperties.swift
//  mealtime
//
//  Created by Kasdan on 12/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var cheap: Bool
    @NSManaged public var dairy_free: Bool
    @NSManaged public var gluten_free: Bool
    @NSManaged public var id: Int16
    @NSManaged public var image: String?
    @NSManaged public var instructions: String?
    @NSManaged public var keto: Bool
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var ready_in_minutes: Int16
    @NSManaged public var servings: Int16
    @NSManaged public var vegan: Bool
    @NSManaged public var vegetarian: Bool
    @NSManaged public var user: User?

}
