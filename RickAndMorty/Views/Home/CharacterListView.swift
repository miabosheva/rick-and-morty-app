import SwiftUI

struct CharacterListView: View {
    
    @EnvironmentObject var viewModel: CharacterViewModel
    var characters: [CharacterEntity]
    
    var body: some View {
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
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                                .padding(.bottom, 4)
                                .foregroundColor(.primaryColor)
                            
                            Text(character.species)
                                .font(.system(size: 16))
                                .fontWeight(.regular)
                                .padding(.bottom, 2)
                                .foregroundColor(.highlightColor)
                            
                            HStack(spacing: 2) {
                                Text(Gender(rawValue: character.gender)?.name() ?? "")
                                Text("•")
                                Text(Status(rawValue: character.status)?.name() ?? "")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        }
                        .padding(.leading, 16)
                    }
                }
                
            }
            .onAppear {
                if character.id == viewModel.characters.last?.id {
                    viewModel.loadData()
                }
            }
            .listRowBackground(Color.secondaryBackgroundColor)
            .listRowSeparatorTint(.primaryColor)
            
        }
        .listStyle(PlainListStyle())
        .background(Color.secondaryBackgroundColor)
    }
}
