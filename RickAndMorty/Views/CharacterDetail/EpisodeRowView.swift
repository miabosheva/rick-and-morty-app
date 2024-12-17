import SwiftUI

struct EpisodeRowView: View {
    
    @EnvironmentObject var viewModel: CharacterViewModel
    var episodeUrl: String
    @State var episode: Episode?
    @State var isLoading: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if let episode = self.episode {
                if !isLoading {
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
                if isLoading {
                    VStack {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        Divider()
                            .background(Color.primaryColor)
                    }
                    .frame(height: 100)
                } else {
                    RoundedRectangle(cornerRadius: 20).overlay {
                        Text("Problem Loading Episode.")
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundColor(Color.highlightColor)
                        
                    }
                    .foregroundColor(Color.secondaryBackgroundColor)
                    .frame(height: 100)
                }
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            Task {
                await loadEpisode(url: episodeUrl)
            }
        }
    }
    
    // MARK: - Episode Network Request
    
    func loadEpisode(url: String) async {
        isLoading = true
        if let episode = await viewModel.fetchEpisodeForCharacter(url: url) {
            self.episode = episode
        }
        isLoading = false
    }
    
}

#Preview {
    EpisodeRowView(episodeUrl: "https://rickandmortyapi.com/api/episode/1")
}
