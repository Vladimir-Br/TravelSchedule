
import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Главный экран")
                    .font(.title)
                    .foregroundColor(Color("AppBlack"))
                Text("Здесь будет выбор маршрута")
                    .font(.subheadline)
                    .foregroundColor(Color("AppGray"))
                    .padding(.top, 8)
            }
        }
    }
}

#Preview {
    MainView()
}
