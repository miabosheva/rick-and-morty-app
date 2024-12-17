import SwiftUI

struct CharacterSpecsView: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.primaryColor)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
    }
}


#Preview {
    CharacterSpecsView(title: "LOCATION", value: "Earth")
}
