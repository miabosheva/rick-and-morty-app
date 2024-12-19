import SwiftUI

struct HomeView: View {
    
//    @FetchRequest(sortDescriptors: []) var characters: FetchedResults<Character>
    
    @EnvironmentObject private var viewModel: CharacterViewModel
    @State private var showAlert = false
    @State private var searchName = ""
    
    var displayedCharacters: [CharacterResponse] {
        searchName.isEmpty ? viewModel.characters : viewModel.searchedCharacters
    }
    
    var searchMode: Bool {
        return searchName != ""
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                            .frame(width: 150, height: 150)
                            .background(.clear)
                            .foregroundStyle(Color.primaryColor)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    if displayedCharacters.isEmpty && searchMode {
                        Text("No Results Found")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .padding(.bottom, 4)
                            .foregroundColor(.primaryColor)
                    } else {
                        CharacterListView(characters: displayedCharacters)
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.secondaryBackgroundColor, for: .navigationBar)
            .background(Color.secondaryBackgroundColor)
            .navigationTitle("Rick and Morty")
        }
        .foregroundColor(Color.primaryColor)
        .tint(Color.primaryColor)
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
        .searchable(text: $searchName, prompt: "Search By Name")
        .onChange(of: searchName) { newValue in
            if !newValue.isEmpty {
                viewModel.fetchSearchData(name: newValue)
            }
        }
    }
}

#Preview {
    HomeView()
}
