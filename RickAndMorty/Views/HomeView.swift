import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: CharacterViewModel
    @State private var showAlert = false
    @State private var searchName = ""
    
    var displayedCharacters: [Character] {
        searchName.isEmpty ? viewModel.characters : viewModel.searchedCharacters
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if displayedCharacters.isEmpty {
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
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.secondaryBackgroundColor, for: .navigationBar)
            .background(Color.secondaryBackgroundColor)
            .navigationTitle("Rick and Morty")
        }
        // Disable refresh on child views (i.e. on Details View)
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
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
