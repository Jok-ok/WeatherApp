// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct SuggestResults: Codable {
    let results: [Suggest]?
}

// MARK: - Result
struct Suggest: Codable {
    let title: Title
    let subtitle: Subtitle?
    let tags: [String]?
    let distance: Distance?
    let address: Address?
    let uri: String?
}

// MARK: - Address
struct Address: Codable {
    let formattedAddress: String?
    let component: [Component]?

    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case component
    }
}

// MARK: - Component
struct Component: Codable {
    let name: String?
    let kind: [String]?
}

// MARK: - Distance
struct Distance: Codable {
    let text: String?
    let value: Double?
}

// MARK: - Subtitle
struct Subtitle: Codable {
    let text: String?
}

// MARK: - Title
struct Title: Codable {
    let text: String
    let hl: [Hl]?
}

// MARK: - Hl
struct Hl: Codable {
    let begin, end: Int?
}
