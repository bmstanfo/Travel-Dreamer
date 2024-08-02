import Foundation

class APIManager {
    
    private let baseURL = "https://api.mocki.io/v1/ce5f60e2" // Mock API URL

    func searchFlights(from origin: String, to destination: String, completion: @escaping (Result<[Flight], Error>) -> Void) {
        let urlString = "\(baseURL)?origin=\(origin)&destination=\(destination)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            do {
                let flights = try JSONDecoder().decode([Flight].self, from: data)
                completion(.success(flights))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct Flight: Decodable {
    let airline: String
    let departure: String
    let arrival: String
    let price: String
}

