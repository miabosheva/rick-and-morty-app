import Foundation

struct CharacterResponseObject: Codable {
    var info: InfoPagination
    var results: [CharacterResponse]
}

struct InfoPagination: Codable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}
