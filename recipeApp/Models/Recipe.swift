import Foundation

struct Recipes: Codable {
    let results: [RecipeElement]?
    let offset, number, totalResults: Int?
}

struct RecipeElement: Codable {
    var id: Int?
    var title: String?
    var calories: Int?
    var image: String?
    var imageType: String?
    var cuisines: [String]?
    var readyInMinutes, cookingMinutes: Int?
    var averageRating: Double?
    var diets: [String]?
    var healthScore: Int?
    var servings: Int?
        
    
}

import Foundation

//struct SimilarRecipe: Codable {
//    let id: Int
//    let title, image: String
//    let imageUrls: [String]
//    let readyInMinutes, servings: Int
//}

typealias SimilarRecipes = [RecipeElement]
