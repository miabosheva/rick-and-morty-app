import SwiftUI

struct CharacterDetailView: View {
    
    var character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ZStack {
                
                Rectangle()
                    .fill(.black)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        AsyncImage(url: URL(string: character.image)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.primaryColor)
                                    .padding(30)
                            default:
                                ProgressView()
                            }
                        }
                    }
                
                LinearGradient(gradient: Gradient(colors: [Color.primaryBackgroundColor, .clear]), startPoint: .bottom, endPoint: .top)
                    .opacity(1)
                    .aspectRatio(1, contentMode: .fill)
            }
            
            
            VStack(alignment: .center, spacing: 18) {
                
                Text(character.name)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(Color.primaryColor)
                
                HStack(spacing: 32) {
                    CharacterSpecsView(title: "SPECIES", value: character.species)
                    CharacterSpecsView(title: "GENDER", value: character.gender.rawValue)
                    CharacterSpecsView(title: "STATUS", value: character.status.rawValue)
                    CharacterSpecsView(title: "ORIGIN", value: "Earth")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 150)
            .padding(.vertical, 8)
            .background(Color.primaryBackgroundColor)
            
            Section(header:
                        VStack {
                Text("EPISODES")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color.primaryColor)
                    .padding(.top, 16)
                
                Text("where \(character.name) appears")
                    .font(.system(size: 14))
                    .fontWeight(.light)
                    .foregroundColor(Color.primaryColor)
                    .padding(.bottom, 16)
            }) {
                
                List(character.episode) { episode in
                    VStack(alignment: .leading) {
                        Text(episode.episodeNumber)
                            .fontWeight(.light)
                            .padding(.vertical, 5)
                            .foregroundColor(Color.primaryColor)
                        
                        Text(episode.name)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .padding(.bottom, 4)
                        
                        Text(episode.airDate)
                            .font(.system(size: 14))
                            .padding(.bottom, 4)
                            .foregroundColor(.gray)
                    }
                    .foregroundColor(Color.highlightColor)
                    .listRowBackground(Color.secondaryBackgroundColor)
                    .listRowSeparatorTint(Color.primaryColor)
                }
            }
            .listStyle(InsetListStyle())
            
        }
        .ignoresSafeArea()
        .background(Color.secondaryBackgroundColor)
        
        // TODO: -  background doesnt show?
    }
}

#Preview {
    CharacterDetailView(character:
                            Character(
                                name: "Rick",
                                species: "Human",
                                image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg",
                                status: .alive,
                                gender: .male,
                                episode: [
                                    Episode(
                                        name: "Rick and Morty go skiing",
                                        airDate: "December 2, 2013",
                                        episodeNumber: "S01E23"),
                                    Episode(
                                        name: "M. Night Shaym-Aliens!",
                                        airDate: "December 2, 2013",
                                        episodeNumber: "S01E23"),
                                    Episode(
                                        name: "M. Night Shaym-Aliens!",
                                        airDate: "December 2, 2013",
                                        episodeNumber: "S01E23"),
                                    Episode(
                                        name: "M. Night Shaym-Aliens!",
                                        airDate: "December 2, 2013",
                                        episodeNumber: "S01E23")
                                ])
    )
}

