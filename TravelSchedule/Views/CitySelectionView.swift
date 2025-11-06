
import SwiftUI

enum StationSelectionType: Identifiable {
    case from
    case to
    
    var id: String {
        switch self {
        case .from: return "from"
        case .to: return "to"
        }
    }
}

struct CitySelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CitySelectionViewModel()
    
    let selectionType: StationSelectionType
    let onStationSelected: (Station) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchQuery)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                if viewModel.isEmpty {
                    EmptyCityState()
                } else {
                    CityList(
                        cities: viewModel.filteredCities,
                        selectionType: selectionType,
                        onStationSelected: onStationSelected
                    )
                    .padding(.top, 16)
                }
            }
            .background(Color("AppWhite"))
            .navigationTitle("Выбор города")
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
        }
    }
}

// MARK: - Search Bar

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("AppGray"))
            
            TextField("Введите запрос", text: $text)
                .foregroundColor(Color("AppBlack"))
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color("AppGray"))
                }
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 8)
        .frame(height: 36)
        .background(Color("AppLight Gray"))
        .cornerRadius(10)
    }
}

// MARK: - City List

struct CityList: View {
    let cities: [City]
    let selectionType: StationSelectionType
    let onStationSelected: (Station) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(cities) { city in
                    NavigationLink {
                        StationSelectionView(
                            city: city,
                            selectionType: selectionType,
                            onStationSelected: onStationSelected
                        )
                    } label: {
                        HStack {
                            Text(city.title)
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

// MARK: - Empty State

struct EmptyCityState: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Город не найден")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color("AppBlack"))
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppWhite"))
    }
}

// MARK: - Preview

#Preview {
    CitySelectionView(
        selectionType: .from,
        onStationSelected: { _ in }
    )
}
