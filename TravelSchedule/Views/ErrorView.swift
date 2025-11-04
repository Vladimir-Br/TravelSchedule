
import SwiftUI

// MARK: - Error Type

enum ErrorType {
    case serverError
    case noInternet
    
    var imageName: String {
        switch self {
        case .serverError:
            return "ServerError"
        case .noInternet:
            return "NoInternet"
        }
    }
    
    var message: String {
        switch self {
        case .serverError:
            return "Ошибка сервера"
        case .noInternet:
            return "Нет интернета"
        }
    }
}

// MARK: - Error View

struct ErrorView: View {
    let errorType: ErrorType
    
    var body: some View {
        ZStack {
            Color("AppWhite")
                .ignoresSafeArea(.container, edges: .top)
            
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(errorType.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 223, height: 223)
                        .cornerRadius(70)
                    
                    Text(errorType.message)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color("AppBlack"))
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Preview

#Preview("Server Error") {
    struct PreviewWrapper: View {
        @State private var selectedTab = 1
        
        var body: some View {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    MainView()
                }
                .tabItem {
                    Image("Schedule")
                        .renderingMode(.template)
                    Text("")
                }
                .tag(0)
                
                NavigationStack {
                    ErrorView(errorType: .serverError)
                }
                .tabItem {
                    Image("Settings")
                        .renderingMode(.template)
                    Text("")
                }
                .tag(1)
            }
            .tint(Color("AppBlack"))
        }
    }
    
    return PreviewWrapper()
}

#Preview("No Internet") {
    struct PreviewWrapper: View {
        @State private var selectedTab = 1
        
        var body: some View {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    MainView()
                }
                .tabItem {
                    Image("Schedule")
                        .renderingMode(.template)
                    Text("")
                }
                .tag(0)
                
                NavigationStack {
                    ErrorView(errorType: .noInternet)
                }
                .tabItem {
                    Image("Settings")
                        .renderingMode(.template)
                    Text("")
                }
                .tag(1)
            }
            .tint(Color("AppBlack"))
        }
    }
    
    return PreviewWrapper()
}
