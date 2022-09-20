import Foundation

struct VideosResponse: Codable {
    let videos: [Videos]
}

struct Videos: Codable {
    let id: String
    let url: String
    let title: String
    let imageUrl: String
}


extension Videos {
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case id, url, title
    }
}
