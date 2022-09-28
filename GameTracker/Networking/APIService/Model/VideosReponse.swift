import Foundation

struct VideosResponse: Codable {
    let videos: [GameVideoResponse]
}

struct GameVideoResponse: Codable, Hashable {
    let id: String
    let url: String
    let title: String
    let imageUrl: String
}


extension GameVideoResponse {
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case id, url, title
    }
}
