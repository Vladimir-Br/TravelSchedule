
import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()
    @State private var selectionType: StationSelectionType?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Stories Placeholder
                StoriesPlaceholder()
               
                VStack(spacing: 16) {
                    RouteSelectionContainer(
                        fromStation: viewModel.fromStation,
                        toStation: viewModel.toStation,
                        onFromTap: {
                            selectionType = .from
                        },
                        onToTap: {
                            selectionType = .to
                        },
                        onSwap: {
                            viewModel.swapStations()
                        }
                    )
                    
                    if viewModel.isFindButtonEnabled {
                        Button(action: {
                            // TODO: Переход на экран расписания
                        }) {
                            Text("Найти")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(Color("AppWhite"))
                                .frame(width: 150, height: 60)
                                .background(Color("AppBlue"))
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .background(Color("AppWhite"))
        .fullScreenCover(item: $selectionType) { type in
            CitySelectionView(
                selectionType: type,
                onStationSelected: { station in
                    switch type {
                    case .from:
                        viewModel.setFromStation(station)
                    case .to:
                        viewModel.setToStation(station)
                    }
                    selectionType = nil
                }
            )
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
    
    var body: some View {
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
    
    private var displayText: String {
        guard let station = station else {
            return label
        }
        
        if let city = MockData.getCity(for: station.code) {
            return "\(city.title) (\(station.title))"
        } else {
            return station.title
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(displayText)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(station != nil ? Color("AppBlack") : Color("AppGray"))
                    .tracking(-0.41)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
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
