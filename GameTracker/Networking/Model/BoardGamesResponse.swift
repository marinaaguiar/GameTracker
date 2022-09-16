import Foundation

struct BoardGamesAtlasResponse: Codable {
    let games: [GamesReponse]
}

struct GamesReponse: Codable {
    let id: String
    let name: String
    let price: String
    let yearPublished: Int
    let minPlayers: Int
    let maxPlayers: Int
    let playtime: String
    let minAge: Int
    let description: String
    let commentary: String
    let thumbUrl: String
    let imageUrl: String
    let mechanics: [Mechanics]
    let categories: [Categories]
    let designers: [Designers]
    let officialUrl: String?
    let descriptionPreview: String
    let rulesUrl: String?
    let numUserRatings: Int
    let averageUserRating: Double
    let averageLearningComplexity: Int
    let rank: Int
}

struct Mechanics: Codable {
    let id: String
    let url: String
}

struct Categories: Codable {
    let id: String
    let url: String
}

struct Designers: Codable {
    let id: String
}

private extension GamesReponse {
    enum CodingKeys: String, CodingKey {
        case yearPublished = "year_published"
        case minPlayers = "min_players"
        case maxPlayers = "max_players"
        case minAge = "min_age"
        case thumbUrl = "thumb_url"
        case imageUrl = "image_url"
        case officialUrl = "official_url"
        case descriptionPreview = "description_preview"
        case rulesUrl = "rules_url"
        case numUserRatings = "num_user_ratings"
        case averageUserRating = "average_user_rating"
        case averageLearningComplexity = "average_learning_complexity"


        case id, name, price, playtime, description, commentary, mechanics, categories, designers, rank
    }
}
