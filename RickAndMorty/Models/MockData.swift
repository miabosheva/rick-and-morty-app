import Foundation

struct MockData {
    public static let character = Character(
        id: 1,
        name: "Rick",
        species: "Human",
        image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg",
        status: .alive,
        gender: .male,
        episode: [""],
        origin: Location(name: "Earth", url: ""),
        location: Location(name: "Earth", url: ""))
    
    public static let episodes = [
        Episode(
            id: 1, name: "Rick and Morty go skiing",
            airDate: "December 2, 2013",
            episodeNumber: "S01E23"),
        Episode(
            id: 2, name: "M. Night Shaym-Aliens!",
            airDate: "December 2, 2013",
            episodeNumber: "S01E23"),
        Episode(
            id: 3, name: "M. Night Shaym-Aliens!",
            airDate: "December 2, 2013",
            episodeNumber: "S01E23"),
        Episode(
            id: 4, name: "M. Night Shaym-Aliens!",
            airDate: "December 2, 2013",
            episodeNumber: "S01E23")
    ]
    
    public static let location = Location(name: "Earth", url: "")
    
    public static let characters = [
        Character(
            id: 1,
            name: "Rick",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
            status: .alive,
            gender: .male,
            episode: [""],
            origin: location,
            location: location),
        Character(
            id: 2,
            name: "Morty",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
            status: .alive,
            gender: .male,
            episode: [""],
            origin: location,
            location: location),
        Character(
            id: 3,
            name: "Beth",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
            status: .alive,
            gender: .female,
            episode: [""],
            origin: location,
            location: location),
        Character(
            id: 4,
            name: "Jerry",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/.jpeg",
            status: .alive, gender: .male,
            episode: [""],
            origin: location,
            location: location)
    ]
}
