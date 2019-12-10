import Foundation

struct Recipes: Codable {
    let results: [RecipeElement]?
    let offset, number, totalResults: Int?
}

struct RecipeElement: Codable {
    let id: Int?
    let title: String?
    let calories: Int?
    let image: String?
    let imageType: String?
    let cuisines: [String]?
    let readyInMinutes, cookingMinutes: Int?
    let averageRating: Double?
    let diets: [String]?
    
}
