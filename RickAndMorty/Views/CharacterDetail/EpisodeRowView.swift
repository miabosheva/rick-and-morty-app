import SwiftUI

struct EpisodeRowView: View {
    
    @EnvironmentObject var viewModel: CharacterViewModel
    
    var episodeUrl: String
    var charId: Int
    
    @State var episode: Episode?
    @State var isLoading: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if isLoading {
                VStack {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Divider()
                        .background(Color.primaryColor)
                }
                .frame(height: 100)
            } else {
                if let episode = self.episode {
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
                await loadEpisode()
            }
        }
    }
    
    // MARK: - Episode Network Request
    
    func fetchEpisode(url: String) async {
        isLoading = true
        await viewModel.fetchEpisodeForCharacter(charId: self.charId, episodeUrl: url)
//        await Task.sleep(1_000_000_000)
        if let index = viewModel.characters.firstIndex(where: { $0.id == charId }) {
            getLoadedEpisode(url: url)
        }
        isLoading = false
    }
    
    // MARK: - Helper Methods
    
    // If episode is loaded for the character, then dont make a network request
    private func loadEpisode() async {
        getLoadedEpisode(url: episodeUrl)
        if self.episode == nil {
            await fetchEpisode(url: episodeUrl)
        }
    }
    
    private func getLoadedEpisode(url: String) {
        if let index = viewModel.characters.firstIndex(where: { $0.id == charId }) {
            if let loadedEpisode = viewModel.characters[index].episodes?.first(where: {$0.url == url}) {
                self.episode = loadedEpisode
            }
        }
    }
}

#Preview {
    EpisodeRowView(episodeUrl: "https://rickandmortyapi.com/api/episode/1", charId: 1)
}
