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
//    let nutrition: [Nutrition]?
}
//
//struct Nutrition: Codable {
//    let title: String?
//    let amount: Double?
//    let unit: String?
//}

