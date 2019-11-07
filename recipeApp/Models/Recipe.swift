import Foundation

struct RecipeElement: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let usedIngredientCount, missedIngredientCount: Int
    let unusedIngredients: [SedIngredient]
    let likes: Int
    let missedIngredients, usedIngredients: [SedIngredient]
}

struct SedIngredient: Codable {
    let id: Int
    let amount: Double
    let unit, unitLong, unitShort, aisle: String
    let name, original, originalString, originalName: String
    let metaInformation: [String]
    let image: String
}

typealias Recipes = [RecipeElement]






