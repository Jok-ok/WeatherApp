import Foundation

class APINetworkManager {
    static func request<DataType: Codable, EndpointType: APIEndpointProtocol>(to endpoint: EndpointType, with completion: ((Result<DataType, SuggestAPIErrors>) -> Void)? ) {
        let queryItems = endpoint.queryItems.compactMap { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard var url = URL(string: endpoint.urlString) else {
            completion?(.failure(.invalidUrl))
            return }
        
        url.append(queryItems: queryItems)
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion?(.failure(.unknownError(error: error)))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion?(.failure(.requestFailed(description: "Request failed")))
                }
                return
            }
            
            guard response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion?(.failure(.invalidStatusCode(statusCode: response.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion?(.failure(.invalidData))
                }
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(DataType.self, from: data)
                print(responseData)
                DispatchQueue.main.async {
                    completion?(.success(responseData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(.failure(.jsonParsingFailure))
                }
            }
        }.resume()
    }
}
