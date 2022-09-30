import Foundation

private struct APIDefinitions {

    static let APIKey = APIConstant.apiKey // replace for "YOUR_API_KEY"
    static let searchMethod = "api.boardgameatlas.com/api"
}

private struct EndPoint {
    enum SearchQueryItem: String {
        case clientId = "client_id"
        case limit
        case gameId = "ids"
        case listId = "list_id"
        case json = "pretty"
        case name
        case fuzzyMatch = "fuzyy_match"
        case mechanicsId = "mechanics"
        case categoriesId = "categories"
        case orderBy = "order_by"
        case ascending
    }

    enum MediaQueryItem: String {
        case clientId = "client_id"
        case limit
        case json = "pretty"
        case gameId = "game_id"
        case ascending
    }

    let queryItems: [URLQueryItem]

    static func list(limitItems: Int, orderedBy: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.boardgameatlas.com"
        components.path = "/api/search"

        components.queryItems = [
            URLQueryItem(
                name: SearchQueryItem.clientId.rawValue,
                value: APIDefinitions.APIKey),
            URLQueryItem(
                name: SearchQueryItem.limit.rawValue,
                value: "\(limitItems)"),
            URLQueryItem(
                name: SearchQueryItem.orderBy.rawValue,
                value: "\(orderedBy)"),
            URLQueryItem(
                name: SearchQueryItem.json.rawValue,
                value: "\(true)")
        ]
        return components.url
    }

    enum MediaTypePath: String {
        case images = "/api/game/images"
        case videos = "/api/game/videos"
    }
    static func media(path: MediaTypePath, limitItems: Int, gameId: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.boardgameatlas.com"
        components.path = path.rawValue

        components.queryItems = [
            URLQueryItem(
                name: MediaQueryItem.clientId.rawValue,
                value: APIDefinitions.APIKey),
            URLQueryItem(
                name: MediaQueryItem.limit.rawValue,
                value: "\(limitItems)"),
            URLQueryItem(
                name: MediaQueryItem.gameId.rawValue,
                value: "\(gameId)"),
            URLQueryItem(
                name: MediaQueryItem.json.rawValue,
                value: "\(true)"),
            URLQueryItem(
                name: MediaQueryItem.ascending.rawValue,
                value: "\(false)")
        ]
        return components.url
    }
}

class APIService {
    enum APIError: Swift.Error {
        case failedToConstructURL
        case wrongEncoding
    }

    enum OrderedBy: String {
        case rank
        case trending
        case average_user_rating
    }

    func loadGameList(limitItems: Int, orderedBy: OrderedBy,completion: @escaping ((Result<BoardGamesAtlasResponse, Error>) -> Void)) {

        guard let url = EndPoint.list(limitItems: limitItems, orderedBy: orderedBy.rawValue) else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        print(url)
        NetworkingService().fetchGenericData(url: url, completion: completion)
    }

    func loadGameImages(limitItems: Int, gameId: String, completion: @escaping ((Result<GameImagesResponse, Error>) -> Void)) {
        guard let url = EndPoint.media(path: .images, limitItems: limitItems, gameId: gameId) else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        print(url)
        NetworkingService().fetchGenericData(url: url, completion: completion)
    }

    func loadGameVideos(limitItems: Int, gameId: String, completion: @escaping ((Result<GameVideosResponse, Error>) -> Void)) {
        guard let url = EndPoint.media(path: .videos, limitItems: limitItems, gameId: gameId) else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        print(url)
        NetworkingService().fetchGenericData(url: url, completion: completion)
    }
}
