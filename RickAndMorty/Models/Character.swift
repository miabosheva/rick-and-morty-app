import Foundation

struct Character: Identifiable {
    var id = UUID()
    var name: String
    var species: String
    var image: String
    var status: Status
    var gender: Gender
    var episode: [Episode]
}

enum Gender: String {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "Unknown"
}

enum Status: String {
    case dead = "Dead"
    case alive = "Alive"
    case unknown = "Unknown"
}
