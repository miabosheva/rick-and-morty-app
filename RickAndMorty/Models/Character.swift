import Foundation

struct Character: Identifiable, Codable {
    var id: Int
    var name: String
    var species: String
    var image: String
    var status: Status
    var gender: Gender
    var episode: [String]
    var origin: Location
    var location: Location
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
