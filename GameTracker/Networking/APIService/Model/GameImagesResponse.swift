import Foundation

struct GameImagesResponse: Codable {
    let images: [GameImageResponse]
}

struct GameImageResponse: Codable, Hashable {
    let createdAt: String 
    let game: GameInfo
    let imageURL: String
}

struct GameInfo: Codable, Hashable {
    let id: String
}

private extension GameImageResponse {
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case imageURL = "large"
        case game
    }
}
