import Foundation

protocol APIEndpointProtocol {
    var urlString: String { get }
    var queryItems: [String: String] { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case update = "UPDATE"
    case put = "PUT"
}
