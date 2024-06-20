import Foundation

protocol APIEndpointProtocol {
    var urlString: String { get }
    var queryItems: [String:String] { get }
}
