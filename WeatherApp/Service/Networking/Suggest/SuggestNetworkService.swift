import Foundation

class SuggestNetworkService: SuggestNetworkServiceProtocol {
    private let apiKey = ApiKeys.suggestApiKey
    private let urlString = "https://suggest-maps.yandex.ru/v1/suggest"
    
    func getSuggests(for prompt: String, completion: @escaping (Result<[Suggest], APIErrors>) -> ()) {
        let queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "text", value: prompt),
            URLQueryItem(name: "types", value: "locality"),
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "results", value: "8")
        ]
        guard var url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return }
        
        url.append(queryItems: queryItems)
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.unknownError(error: error)))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(description: "Request failed")))

                }
                return
            }
            
            guard response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidStatusCode(statusCode: response.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }
            
            do {
                let suggests = try JSONDecoder().decode(SuggestResults.self, from: data)
                print(suggests)
                DispatchQueue.main.async {
                    completion(.success(suggests.results ?? []))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }.resume()
    }
}

