import Foundation

struct CharacterResponse: Identifiable, Codable, Comparable, Hashable {
    var id: Int
    var name: String
    var species: String
    var image: String
    var status: Status
    var gender: Gender
    var episodeUrls: [String]
    var origin: Location
    var location: Location
    var episodes: [Episode]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case species
        case image
        case status
        case gender
        case episodeUrls = "episode"
        case origin
        case location
        case episodes
    }
    
    static func < (lhs: CharacterResponse, rhs: CharacterResponse) -> Bool {
        lhs.id < lhs.id
    }
    
    static func == (lhs: CharacterResponse, rhs: CharacterResponse) -> Bool {
        lhs.id == lhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Location: Codable {
    var name: String
    var url: String
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}

enum Status: String, Codable {
    case dead = "Dead"
    case alive = "Alive"
    case unknown = "unknown"
}
