import SwiftUI

struct EpisodeRowView: View {
    
    @EnvironmentObject var viewModel: CharacterViewModel
    
    var episodeUrl: String
    var charId: Int
    
    @State private var episode: EpisodeEntity?
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 100)
            } else {
                if let episode = episode {
                    VStack(alignment: .leading) {
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
                    RoundedRectangle(cornerRadius: 20)
                        .overlay {
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
        .task {
            await loadEpisode()
        }
    }
    
    // MARK: - Episode Handling
    
    private func loadEpisode() async {
        if let localEpisode = getLocalEpisode() {
            self.episode = localEpisode
        } else {
            await fetchAndSaveEpisode()
        }
    }
    
    private func fetchAndSaveEpisode() async {
        isLoading = true
        defer { isLoading = false }
        print("FETCHING EPISODE")
        await viewModel.fetchEpisodeForCharacter(charId: charId, episodeUrl: episodeUrl)
        self.episode = getLocalEpisode()
    }
    
    private func getLocalEpisode() -> EpisodeEntity? {
        guard let character = viewModel.characters.first(where: { $0.id == charId }),
              let loadedEpisode = character.episodes.first(where: { ($0 as? EpisodeEntity)?.url == episodeUrl }) as? EpisodeEntity else {
            return nil
        }
        return loadedEpisode
    }
}

#Preview {
    EpisodeRowView(episodeUrl: "https://rickandmortyapi.com/api/episode/1", charId: 1)
}
