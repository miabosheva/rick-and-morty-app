import SwiftUI

struct CharacterListView: View {
    
    @StateObject private var viewModel = CharacterViewModel()
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.characters) { character in
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
                                    Text(character.gender.rawValue)
                                    Text("•")
                                    Text(character.status.rawValue)
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
            .refreshable {
                viewModel.refreshData()
            }
            .onReceive(viewModel.$error, perform: { error in
                if error != nil {
                    showAlert.toggle()
                }
            })
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? ""))
            })
            .background(Color.secondaryBackgroundColor)
            .listStyle(PlainListStyle())
        }
        .tint(Color.primaryColor)
    }
}

#Preview {
    CharacterListView()
}
