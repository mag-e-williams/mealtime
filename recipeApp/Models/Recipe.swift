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
        
    
//    init(id: Int?, title: String?, calories: Int?, image: String?, imageType: String?, cuisines: [String]?, readyInMinutes: Int?, cookingMinutes: Int?, averageRating: Double?, diets: [String]?) {
//        self.id = id
//        self.title = title
//        self.calories = calories
//        self.image = image
//        self.imageType = imageType
//        self.cuisines = cuisines
//        self.readyInMinutes = readyInMinutes
//        self.cookingMinutes = cookingMinutes
//        self.averageRating = averageRating
//        self.diets = diets
//    }
    
}

//extension RecipeElement: Codable {
//        
//}
