import Foundation

struct Recipes: Codable {
    let results: [RecipeElement]?
    let offset, number, totalResults: Int?
}

struct RecipeElement: Codable {
    let id: Int?
    let title: String?
    let image: String?
    let imageType: String?
    let cuisines: [String]?
    let preparationMinutes, cookingMinutes: Int?
    let diets: [String]?
}
