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



func queryAPI(_ url: String) -> [RecipeElement]{
    let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in guard let data = data else {
            print("Error: No data to decode")
            return
        }
        
        guard let result = try? JSONDecoder().decode(Recipes.self, from: data) else {
            print("Error: Couldn't decode data into a result")
            return
        }
        print(type(of: result))
        return result
    }
    task.resume()
    return []
}



