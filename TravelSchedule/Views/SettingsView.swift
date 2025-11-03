
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Экран настроек")
                    .font(.title)
                    .foregroundColor(Color("AppBlack"))
                Text("Будет реализован в следующем спринте")
                    .font(.subheadline)
                    .foregroundColor(Color("AppGray"))
                    .padding(.top, 8)
            }
        }
    }
}

#Preview {
    SettingsView()
}
