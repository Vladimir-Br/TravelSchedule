
import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()
    @State private var selectionType: StationSelectionType?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                StoriesSection(
                    stories: viewModel.stories,
                    onStoryTap: { index in
                        viewModel.presentStory(at: index)
                    }
                )
                
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
                    
                    if viewModel.isFindButtonEnabled,
                       let fromStation = viewModel.fromStation,
                       let toStation = viewModel.toStation {
                        NavigationLink {
                            ScheduleView(
                                fromStation: fromStation,
                                toStation: toStation
                            )
                        } label: {
                            Text("Найти")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 150, height: 60)
                                .background(Color(.appBlue))
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
.background(Color(.appWhite))
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
                    .fill(Color.white)
            )
           
            Button(action: onSwap) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "arrow.2.squarepath")
                        .font(.system(size: 18))
                        .foregroundColor(Color(.appBlue))
                }
            }
        }
        .frame(height: 96)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.appBlue))
        )
    }
}

// MARK: - Stories Section

private struct StoriesSection: View {
    let stories: [Story]
    let onStoryTap: (Int) -> Void
    
    var body: some View {
        VStack {
            StoriesView(
                stories: stories,
                onStoryTap: onStoryTap
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 188)
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
                    .foregroundColor(station != nil ? Color.black : Color(.appGray))
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
