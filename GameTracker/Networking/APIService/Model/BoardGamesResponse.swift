import Foundation

struct BoardGamesAtlasResponse: Codable {
    let games: [GameResponse]
}

struct GameResponse: Codable, Hashable {
    let id: String
    let name: String
    let price: String
    let yearPublished: Int?
    let players: String?
    let minPlayers: Int?
    let maxPlayers: Int?
    let playtime: String?
    let minAge: Int?
    let description: String
    let descriptionPreview: String
    let commentary: String
    let thumbUrl: String
    let imageUrl: String
    let images: Images
    let mechanics: [Mechanics]
    let categories: [Categories]
    let designers: [Designers]
    let officialUrl: String?
    let rulesUrl: String?
    let numUserRatings: Int
    let averageUserRating: Double
    let averageLearningComplexity: Double
    let rank: Int

    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: GameResponse, rhs: GameResponse) -> Bool {
      return lhs.identifier == rhs.identifier
    }

  private let identifier = UUID()

}

struct Images: Codable {
    let thumb: String
    let small: String
    let medium: String
    let large: String
    let original: String
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

private extension GameResponse {
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


        case id, name, price, playtime, description, commentary, images, mechanics, categories, designers, rank, players
    }
}
