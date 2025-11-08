
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

                contentView
            }
            .background(Color(.appWhite))
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(.appBlack))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
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
}

// MARK: - Search Bar

struct SearchBar: View {
    @Binding var text: String
    @Environment(\.colorScheme) private var colorScheme

    private var iconColor: Color { colorScheme == .dark ? .secondary : Color(.appGray) }
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.appGray).opacity(0.35) : Color(.appLightGray)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(iconColor)

            TextField(
                "",
                text: $text,
                prompt: Text("Введите запрос").foregroundColor(.secondary)
            )
            .foregroundColor(.primary)
            .tint(.primary)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(iconColor)
                }
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 8)
        .frame(height: 36)
        .background(backgroundColor)
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
                    CityRow(
                        city: city,
                        selectionType: selectionType,
                        onStationSelected: onStationSelected
                    )
                }
            }
        }
    }
}

// MARK: - City Row

private struct CityRow: View {
    let city: City
    let selectionType: StationSelectionType
    let onStationSelected: (Station) -> Void

    var body: some View {
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
                    .foregroundColor(Color(.appBlack))
                    .tracking(-0.41)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Color(.appBlack))
            }
            .frame(height: 60)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Empty State

struct EmptyCityState: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Город не найден")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.appBlack))
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.appWhite))
    }
}

// MARK: - Preview

#Preview {
    CitySelectionView(
        selectionType: .from,
        onStationSelected: { _ in }
    )
}
