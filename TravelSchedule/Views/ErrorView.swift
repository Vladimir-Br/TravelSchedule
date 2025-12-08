
import SwiftUI

// MARK: - Error Type

enum ErrorType {
    case serverError
    case noInternet
    
    var imageResource: ImageResource {
        switch self {
        case .serverError:
            return .serverError
        case .noInternet:
            return .noInternet
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
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Image(errorType.imageResource)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 223, height: 223)
                    .clipShape(RoundedRectangle(cornerRadius: 70))
                
                Text(errorType.message)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.appBlack))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.appWhite))
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Preview

#Preview("Server Error") {
    TabView(selection: .constant(1)) {
        Text("")
            .tabItem {
                Image(.schedule)
                    .renderingMode(.template)
            }
            .tag(0)
        
        NavigationStack {
            ErrorView(errorType: .serverError)
        }
        .tabItem {
            Image(.settings)
                .renderingMode(.template)
        }
        .tag(1)
    }
    .tint(Color(.appBlack))
}

#Preview("No Internet") {
    TabView(selection: .constant(1)) {
        Text("")
            .tabItem {
                Image(.schedule)
                    .renderingMode(.template)
            }
            .tag(0)
        
        NavigationStack {
            ErrorView(errorType: .noInternet)
        }
        .tabItem {
            Image(.settings)
                .renderingMode(.template)
        }
        .tag(1)
    }
    .tint(Color(.appBlack))
}
