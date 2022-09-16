import Foundation

private struct APIDefinitions {

    static let APIKey = APIConstant.apiKey // replace for "YOUR_API_KEY"
    static let searchMethod = "api.boardgameatlas.com/api"
}

private struct EndPoint {
    enum QueryItem: String {
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

    let queryItems: [URLQueryItem]

    static func list(limitItems: Int, orderedBy: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.boardgameatlas.com"
        components.path = "/api/search"

        components.queryItems = [
            URLQueryItem(
                name: QueryItem.clientId.rawValue,
                value: APIDefinitions.APIKey),
            URLQueryItem(
                name: QueryItem.limit.rawValue,
                value: "\(limitItems)"),
            URLQueryItem(
                name: QueryItem.orderBy.rawValue,
                value: "\(orderedBy)"),
            URLQueryItem(
                name: QueryItem.json.rawValue,
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
    }

    func loadGameList(limitItems: Int, orderedBy: OrderedBy,completion: @escaping ((Result<BoardGamesAtlasResponse, Error>) -> Void)) {

        guard let url = EndPoint.list(limitItems: limitItems, orderedBy: orderedBy.rawValue) else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        print(url)
        NetworkingService().fetchGenericData(url: url, completion: completion)
    }
}
