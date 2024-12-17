import SwiftUI

struct CharacterDetailView: View {
    
    @EnvironmentObject var viewModel: CharacterViewModel
    @State var character: Character
    @State private var showAlert = false
    @State private var episodes: [String: Episode] = [:]
    
    init(character: Character) {
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
                            
                            HStack(spacing: 32) {
                                CharacterSpecsView(title: "SPECIES", value: character.species)
                                CharacterSpecsView(title: "GENDER", value: character.gender.rawValue)
                                CharacterSpecsView(title: "STATUS", value: character.status.rawValue)
                                CharacterSpecsView(title: "ORIGIN", value: "Earth")
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 150)
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
                        
                        ForEach(character.episode, id: \.self) { episodeUrl in
                            EpisodeRowView(episodeUrl: episodeUrl)
                        }
                    }
                    .padding(.bottom, 32)
                    .background(Color.primaryBackgroundColor)
                }
            }
            .toolbarBackground(Color.primaryBackgroundColor.opacity(0.2),for: .navigationBar)
        }
        .ignoresSafeArea()
        .background(Color.primaryBackgroundColor)
    }
}

#Preview {
    CharacterDetailView(character: MockData.character)
}
