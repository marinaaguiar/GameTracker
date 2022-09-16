import Foundation

enum NetworkingError: Error {
    case failedToGetData
}

class NetworkingService {

    private var sharedSession: URLSession { URLSession.shared }

    func fetchGenericData<T: Decodable>(url: URL, completion: @escaping(Result<T, Error>) -> Void) {

        let task = sharedSession.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                fatalError("Not able to fetch data")
            }

            do {
                let genericData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(genericData))
            }
            catch {
                completion(.failure(error))
                print("\(error.localizedDescription)")
            }
        }
        task.resume()
    }
}



