import Foundation
import UIKit

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
        case exact
    }

    enum MediaQueryItem: String {
        case clientId = "client_id"
        case limit
        case json = "pretty"
        case gameId = "game_id"
        case ascending
    }

    enum TypePath: String {
        case search = "/api/search"
        case images = "/api/game/images"
        case videos = "/api/game/videos"
    }

    let queryItems: [URLQueryItem]

    static func list(limitItems: Int, orderedBy: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.boardgameatlas.com"
        components.path = TypePath.search.rawValue

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

    static func mediaContent(path: TypePath, limitItems: Int, gameId: String) -> URL? {
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

    static func filteredList(limitItems: Int, filterBy: String, maxNumber: Int, orderedBy: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.boardgameatlas.com"
        components.path = TypePath.search.rawValue

        components.queryItems = [
            URLQueryItem(
                name: SearchQueryItem.clientId.rawValue,
                value: APIDefinitions.APIKey),
            URLQueryItem(
                name: SearchQueryItem.limit.rawValue,
                value: "\(limitItems)"),
            URLQueryItem(
                name: filterBy,
                value: "\(maxNumber)"),
            URLQueryItem(
                name: SearchQueryItem.orderBy.rawValue,
                value: "\(orderedBy)"),
            URLQueryItem(
                name: SearchQueryItem.json.rawValue,
                value: "\(true)")
        ]
        return components.url
    }

    static func filteredList(limitItems: Int, filterBy name: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.boardgameatlas.com"
        components.path = TypePath.search.rawValue

        components.queryItems = [
            URLQueryItem(
                name: SearchQueryItem.clientId.rawValue,
                value: APIDefinitions.APIKey),
            URLQueryItem(
                name: SearchQueryItem.limit.rawValue,
                value: "\(limitItems)"),
            URLQueryItem(
                name: SearchQueryItem.name.rawValue,
                value: "\(name)"),
            URLQueryItem(
                name: SearchQueryItem.json.rawValue,
                value: "\(true)"),
            URLQueryItem(
                name: SearchQueryItem.exact.rawValue,
                value: "\(true)")
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
        guard let url = EndPoint.mediaContent(path: .images, limitItems: limitItems, gameId: gameId) else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        print(url)
        NetworkingService().fetchGenericData(url: url, completion: completion)
    }

    func loadGameVideos(limitItems: Int, gameId: String, completion: @escaping ((Result<GameVideosResponse, Error>) -> Void)) {
        guard let url = EndPoint.mediaContent(path: .videos, limitItems: limitItems, gameId: gameId) else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        print(url)
        NetworkingService().fetchGenericData(url: url, completion: completion)
    }

    func loadGameListFiltered(limitItems: Int, filterBy: FilterParameter, maxNumber: Int, orderedBy: OrderedBy, completion: @escaping ((Result<BoardGamesAtlasResponse, Error>) -> Void)) {
        guard let url = EndPoint.filteredList(limitItems: limitItems, filterBy: filterBy.rawValue, maxNumber: maxNumber, orderedBy: orderedBy.rawValue) else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        print(url)
        NetworkingService().fetchGenericData(url: url, completion: completion)
    }

    func loadGameListFiltered(limitItems: Int, by name: String, completion: @escaping((Result<BoardGamesAtlasResponse, Error>) -> Void)) {

        guard let url = EndPoint.filteredList(limitItems: limitItems, filterBy: name) else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        print(url)
        NetworkingService().fetchGenericData(url: url, completion: completion)
    }
}

//https://api.boardgameatlas.com/api/search?pretty=true&client_id=gHoBds7We9&name=cata&exact=true

// https://api.boardgameatlas.com/api/game/videos?pretty=true&limit=20&client_id=gHoBds7We9&max_playtime=15
