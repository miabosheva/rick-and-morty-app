import Foundation

struct Episode: Identifiable, Codable{
    var id: Int
    var name: String
    var airDate: String
    var episodeNumber: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episodeNumber = "episode"
        case url
    }
}
