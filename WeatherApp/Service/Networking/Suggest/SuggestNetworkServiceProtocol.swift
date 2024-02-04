import Foundation

protocol SuggestNetworkServiceProtocol {
    func getSuggests(for prompt: String, completion: @escaping (Result<[Suggest], SuggestAPIErrors>) -> ()) 
}
