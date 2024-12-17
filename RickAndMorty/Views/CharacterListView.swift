import SwiftUI

struct CharacterListView: View {
    
    let characters = [
        Character(name: "Rick", species: "Human", image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg", status: .alive, gender: .male, episode: [Episode( name: "Rick and Morty go skiing", airDate: "December 2, 2013", episodeNumber: "S01E23"), Episode( name: "M. Night Shaym-Aliens!", airDate: "December 2, 2013", episodeNumber: "S01E23")]),
        Character(name: "Morty", species: "Human", image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg", status: .alive, gender: .male, episode: [Episode( name: "Rick and Morty go skiing", airDate: "December 2, 2013", episodeNumber: "S01E23"), Episode( name: "M. Night Shaym-Aliens!", airDate: "December 2, 2013", episodeNumber: "S01E23")]),
        Character(name: "Beth", species: "Human", image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg", status: .alive, gender: .female, episode: [Episode( name: "Rick and Morty go skiing", airDate: "December 2, 2013", episodeNumber: "S01E23"), Episode( name: "M. Night Shaym-Aliens!", airDate: "December 2, 2013", episodeNumber: "S01E23")]),
        Character(name: "Jerry", species: "Human", image: "https://rickandmortyapi.com/api/character/avatar/.jpeg", status: .alive, gender: .male, episode: [Episode( name: "Rick and Morty go skiing", airDate: "December 2, 2013", episodeNumber: "S01E23"), Episode( name: "M. Night Shaym-Aliens!", airDate: "December 2, 2013", episodeNumber: "S01E23")])
    ]
    
    var body: some View {
        NavigationStack {
            List(characters) { character in
                NavigationLink(destination: CharacterDetailView(character: character)) {
                    HStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.primaryBackgroundColor)
                            .frame(width: 100, height: 100)
                            .overlay {
                                AsyncImage(url: URL(string: character.image)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.primaryColor)
                                            .padding(30)
                                    default:
                                        ProgressView()
                                    }
                                }
                            }
                        HStack {
                            VStack(alignment: .leading) {
                                Text(character.name)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .padding(.bottom, 4)
                                
                                Text(character.species)
                                    .font(.system(size: 16))
                                    .fontWeight(.regular)
                                
                                HStack(spacing: 2) {
                                    Text(character.gender.rawValue)
                                    Text("•")
                                    Text(character.status.rawValue)
                                }
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            }
                            .padding(.leading, 8)
                        }
                        .foregroundColor(.primaryColor)
                    }
                }
                .listRowBackground(Color.secondaryBackgroundColor)
                .listRowSeparatorTint(.primaryColor)
            }
            .background(Color.secondaryBackgroundColor)
            .listStyle(PlainListStyle())
        }
        .tint(Color.primaryColor)
    }
}

#Preview {
    CharacterListView()
}
