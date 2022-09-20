import Foundation

struct ImagesResponse: Codable {
    let images: [Images]
}

struct Images: Codable {
    let id: String
    let url: String
    let game: GameInfo
}

struct GameInfo: Codable {
    let id: String
}
