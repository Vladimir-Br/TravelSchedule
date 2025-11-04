
import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()
    @State private var showCitySelection = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Stories Placeholder
                StoriesPlaceholder()
               
                RouteSelectionContainer(
                    fromStation: viewModel.fromStation,
                    toStation: viewModel.toStation,
                    onFromTap: {
                        // TODO: Переход на выбор города/станции для "Откуда"
                        showCitySelection = true
                    },
                    onToTap: {
                        // TODO: Переход на выбор города/станции для "Куда"
                        showCitySelection = true
                    },
                    onSwap: {
                        viewModel.swapStations()
                    },
                    onFind: {
                        // TODO: Переход на экран расписания
                    },
                    isFindButtonEnabled: viewModel.isFindButtonEnabled
                )
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .background(Color("AppWhite"))
        .fullScreenCover(isPresented: $showCitySelection) {
            // TODO: CitySelectionView
            Text("Выбор города")
        }
    }
}

// MARK: - Stories Placeholder

struct StoriesPlaceholder: View {
    var body: some View {
        VStack {
            Text("Здесь будут сторис")
                .font(.system(size: 17))
                .foregroundColor(Color("AppGray"))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 188)
        .background(Color("AppWhite"))
    }
}

// MARK: - Route Selection Container

struct RouteSelectionContainer: View {
    let fromStation: Station?
    let toStation: Station?
    let onFromTap: () -> Void
    let onToTap: () -> Void
    let onSwap: () -> Void
    let onFind: () -> Void
    let isFindButtonEnabled: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 16) {
                VStack(spacing: 0) {
                    
                    RouteFieldButton(
                        label: "Откуда",
                        station: fromStation,
                        action: onFromTap
                    )
                    
                    RouteFieldButton(
                        label: "Куда",
                        station: toStation,
                        action: onToTap
                    )
                }
                .padding(.trailing, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("AppWhite"))
                )
                
                // Кнопка swap
                Button(action: onSwap) {
                    ZStack {
                        Circle()
                            .fill(Color("AppWhite"))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "arrow.2.squarepath")
                            .font(.system(size: 18))
                            .foregroundColor(Color("AppBlue"))
                    }
                }
            }
            .frame(height: 96)
            
            if isFindButtonEnabled {
                Button(action: onFind) {
                    Text("Найти")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color("AppWhite"))
                        .frame(width: 150, height: 60)
                        .background(Color("AppBlue"))
                        .cornerRadius(16)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("AppBlue"))
        )
    }
}

// MARK: - Route Field Button

struct RouteFieldButton: View {
    let label: String
    let station: Station?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let station = station {
                    Text(station.title)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color("AppBlack"))
                        .tracking(-0.41)
                        .lineLimit(1)
                        .truncationMode(.tail)
                } else {
                    Text(label)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color("AppGray"))
                        .tracking(-0.41)
                }
                
                Spacer()
            }
            .frame(height: 48)
            .padding(.leading, 16) 
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainView()
}
