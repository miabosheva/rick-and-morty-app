import Foundation

struct CharacterResponse: Codable {
    var info: InfoPagination
    var results: [Character]
}

struct InfoPagination: Codable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}
