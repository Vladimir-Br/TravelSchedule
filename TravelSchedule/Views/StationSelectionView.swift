
import SwiftUI

struct StationSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: StationSelectionViewModel
    
    let selectionType: StationSelectionType
    let onStationSelected: (Station) -> Void
    
    init(
        city: City,
        selectionType: StationSelectionType,
        onStationSelected: @escaping (Station) -> Void
    ) {
        self._viewModel = State(initialValue: StationSelectionViewModel(city: city))
        self.selectionType = selectionType
        self.onStationSelected = onStationSelected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $viewModel.searchQuery)
                .padding(.horizontal, 16)
                .padding(.top, 8)
            
            StationList(
                stations: viewModel.filteredStations,
                onSelect: { station in
                    onStationSelected(station)
                }
            )
            .padding(.top, 16)
        }
        .background(Color("AppWhite"))
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("AppBlack"))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Station List

struct StationList: View {
    let stations: [Station]
    let onSelect: (Station) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(stations) { station in
                    Button {
                        onSelect(station)
                    } label: {
                        HStack {
                            Text(station.title)
                                .font(.system(size: 17))
                                .foregroundColor(Color("AppBlack"))
                                .tracking(-0.41)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("AppBlack"))
                        }
                        .frame(height: 60)
                        .padding(.horizontal, 16)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        StationSelectionView(
            city: City(code: "MSK", title: "Москва"),
            selectionType: .from,
            onStationSelected: { _ in }
        )
    }
}
