import SwiftUI

struct CharacterDetailView: View {
    
    @EnvironmentObject var viewModel: CharacterViewModel
    var character: CharacterResponse
    
    init(character: CharacterResponse) {
        self.character = character
    }
    
    var body: some View {
        
        ZStack {
            // MARK: - Background Image
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.black)
                        .aspectRatio(1, contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 400)
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
                        .ignoresSafeArea()
                }
                Spacer()
            }
            
            // MARK: - Contents
            ScrollView {
                
                VStack (spacing: 0) {
                    
                    // MARK: - Title and Specs
                    
                    VStack(spacing: 0) {
                        
                        LinearGradient(gradient: Gradient(colors: [Color.primaryBackgroundColor, .clear]), startPoint: .bottom, endPoint: .top)
                            .opacity(1)
                            .aspectRatio(1, contentMode: .fill)
                        
                        
                        VStack(alignment: .center, spacing: 18) {
                            
                            Text(character.name)
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                                .foregroundColor(Color.primaryColor)
                                .padding(.horizontal, 16)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                            
                            HStack(spacing: 32) {
                                CharacterSpecsView(title: "SPECIES", value: character.species)
                                CharacterSpecsView(title: "GENDER", value: character.gender.rawValue)
                                CharacterSpecsView(title: "STATUS", value: character.status.rawValue)
                                CharacterSpecsView(title: "ORIGIN", value: "Earth")
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .padding(.bottom, 32)
                        .background(Color.primaryBackgroundColor)
                    }
                    
                    // MARK: - Episodes Stack
                    
                    VStack {
                        
                        Divider()
                            .background(Color.primaryColor)
                        
                        VStack {
                            Text("EPISODES")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(Color.primaryColor)
                                .padding(.top, 16)
                            
                            Text("where \(character.name) appears")
                                .font(.system(size: 16))
                                .fontWeight(.light)
                                .foregroundColor(.gray)
                                .padding(.bottom, 16)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        
                        LazyVStack {
                            // If the episodes have been alrerady loaded
                            if let episodes = self.character.episodes {
                                ForEach(episodes) { episode in
                                    Text(episode.episodeNumber)
                                        .fontWeight(.light)
                                        .padding(.bottom, 4)
                                        .padding(.top, 8)
                                        .foregroundColor(Color.primaryColor)
                                    
                                    Text(episode.name)
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .padding(.bottom, 4)
                                        .foregroundColor(Color.highlightColor)
                                    
                                    Text(episode.airDate)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.bottom, 8)
                                    
                                    Divider()
                                        .background(Color.primaryColor)
                                }
                            } else {
                                ForEach(character.episodeUrls, id: \.self) { episodeUrl in
                                    EpisodeRowView(episodeUrl: episodeUrl, charId: character.id)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 32)
                    .background(Color.primaryBackgroundColor)
                }
            }
            .tint(Color.primaryColor)
            .toolbarBackground(Color.primaryBackgroundColor.opacity(0.2),for: .navigationBar)
        }
//        // Disable refresh on child views (i.e. on Details View)
//        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
        .refreshable {
            if let index = viewModel.characters.firstIndex(where: { $0.id == self.character.id }) {
                print(viewModel.characters[index].episodes?.count)
                viewModel.characters[index].episodes?.removeAll()
                print(viewModel.characters[index].episodes?.count)
            }
        }
        .ignoresSafeArea()
        .background(Color.primaryBackgroundColor)
    }
}

#Preview {
    CharacterDetailView(character: MockData.character)
}
