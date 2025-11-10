

import SwiftUI

// MARK: - SelectionStyle

private enum SelectionStyle {
    case checkbox
    case radio
    
    var selectedIcon: String {
        switch self {
        case .checkbox: return "checkmark.square.fill"
        case .radio: return "largecircle.fill.circle"
        }
    }
    
    var unselectedIcon: String {
        switch self {
        case .checkbox: return "square"
        case .radio: return "circle"
        }
    }
}

// MARK: - SelectableRow

private struct SelectableRow: View {
    let title: String
    let isSelected: Bool
    let style: SelectionStyle
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(Color(.appBlack))
                
                Spacer()
                
                Image(systemName: isSelected ? style.selectedIcon : style.unselectedIcon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(.appBlack))
            }
            .frame(height: 60)
            .padding(.horizontal, 16)
            .background(Color(.appWhite))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - FiltersView

struct FiltersView: View {
    @Binding var includeTransfers: Bool?
    @Binding var selectedFilters: Set<DepartureFilter>
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempIncludeTransfers: Bool?
    @State private var tempSelectedFilters: Set<DepartureFilter>
    
    init(
        includeTransfers: Binding<Bool?>,
        selectedFilters: Binding<Set<DepartureFilter>>
    ) {
        self._includeTransfers = includeTransfers
        self._selectedFilters = selectedFilters
        self._tempIncludeTransfers = State(initialValue: includeTransfers.wrappedValue)
        self._tempSelectedFilters = State(initialValue: selectedFilters.wrappedValue)
    }
    
    private var isApplyVisible: Bool {
        tempIncludeTransfers != nil || !tempSelectedFilters.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                departureSection
                transfersSection
                
                if isApplyVisible {
                    Button(action: applyFilters) {
                        Text("Применить")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color(.white))
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color(.appBlue))
                            .cornerRadius(16)
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
        }
        .background(Color(.appWhite))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(.appBlack))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var departureSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Время отправления")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.appBlack))

            VStack(spacing: 0) {
                ForEach([DepartureFilter.morning, .afternoon, .evening, .night], id: \.self) { filter in
                    SelectableRow(
                        title: filter.title,
                        isSelected: tempSelectedFilters.contains(filter),
                        style: .checkbox,
                        action: { toggleFilter(filter) }
                    )
                }
            }
        }
    }

    private var transfersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Показывать варианты с пересадками")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.appBlack))

            VStack(spacing: 0) {
                SelectableRow(
                    title: "Да",
                    isSelected: tempIncludeTransfers == true,
                    style: .radio,
                    action: { toggleTransfers(true) }
                )
                SelectableRow(
                    title: "Нет",
                    isSelected: tempIncludeTransfers == false,
                    style: .radio,
                    action: { toggleTransfers(false) }
                )
            }
        }
    }

    private func toggleFilter(_ filter: DepartureFilter) {
        if tempSelectedFilters.contains(filter) {
            tempSelectedFilters.remove(filter)
        } else {
            tempSelectedFilters.insert(filter)
        }
    }
    
    private func toggleTransfers(_ value: Bool) {
        if tempIncludeTransfers == value {
            tempIncludeTransfers = nil
        } else {
            tempIncludeTransfers = value
        }
    }
    
    private func applyFilters() {
        selectedFilters = tempSelectedFilters
        includeTransfers = tempIncludeTransfers
        dismiss()
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var includeTransfers: Bool? = nil
        @State private var filters: Set<DepartureFilter> = []

        var body: some View {
            NavigationStack {
                FiltersView(
                    includeTransfers: $includeTransfers,
                    selectedFilters: $filters
                )
            }
        }
    }

    return PreviewWrapper()
}
