import Foundation

struct MockData {
    public static let character = CharacterResponse(
        id: 1,
        name: "Rick",
        species: "Human",
        image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg",
        status: .alive,
        gender: .male,
        episodeUrls: [""],
        origin: Location(name: "Earth", url: ""),
        location: Location(name: "Earth", url: ""),
        episodes: episodes)
    
    public static let episodes = [
        Episode(
            id: 1, name: "Rick and Morty go skiing",
            airDate: "December 2, 2013",
            episodeNumber: "S01E23",
            url: ""),
        Episode(
            id: 2, name: "M. Night Shaym-Aliens!",
            airDate: "December 2, 2013",
            episodeNumber: "S01E23",
            url: ""),
        Episode(
            id: 3, name: "M. Night Shaym-Aliens!",
            airDate: "December 2, 2013",
            episodeNumber: "S01E23",
            url: ""),
        Episode(
            id: 4, name: "M. Night Shaym-Aliens!",
            airDate: "December 2, 2013",
            episodeNumber: "S01E23",
            url: "")
    ]
    
    public static let location = Location(name: "Earth", url: "")
    
    public static let characters = [
        CharacterResponse(
            id: 1,
            name: "Rick",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
            status: .alive,
            gender: .male,
            episodeUrls: [""],
            origin: location,
            location: location,
            episodes: episodes),
        CharacterResponse(
            id: 2,
            name: "Morty",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
            status: .alive,
            gender: .male,
            episodeUrls: [""],
            origin: location,
            location: location,
            episodes: episodes),
        CharacterResponse(
            id: 3,
            name: "Beth",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
            status: .alive,
            gender: .female,
            episodeUrls: [""],
            origin: location,
            location: location,
            episodes: episodes),
        CharacterResponse(
            id: 4,
            name: "Jerry",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/.jpeg",
            status: .alive, gender: .male,
            episodeUrls: [""],
            origin: location,
            location: location,
            episodes: episodes),
    ]
}
