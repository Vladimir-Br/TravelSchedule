
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
    
    @State private var viewModel: FiltersViewModel?
    
    init(
        includeTransfers: Binding<Bool?>,
        selectedFilters: Binding<Set<DepartureFilter>>
    ) {
        self._includeTransfers = includeTransfers
        self._selectedFilters = selectedFilters
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                departureSection
                transfersSection
                
                applyButton
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
        .onAppear {
            guard viewModel == nil else { return }
            let currentIncludeTransfers: Bool? = _includeTransfers.wrappedValue
            let currentSelectedFilters: Set<DepartureFilter> = _selectedFilters.wrappedValue
            viewModel = FiltersViewModel(
                includeTransfers: currentIncludeTransfers,
                selectedFilters: currentSelectedFilters
            )
        }
    }

    @ViewBuilder
    private var departureSection: some View {
        if let viewModel = viewModel {
            VStack(alignment: .leading, spacing: 16) {
                Text("Время отправления")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.appBlack))

                VStack(spacing: 0) {
                    ForEach([DepartureFilter.morning, .afternoon, .evening, .night], id: \.self) { filter in
                        SelectableRow(
                            title: filter.title,
                            isSelected: viewModel.tempSelectedFilters.contains(filter),
                            style: .checkbox,
                            action: { viewModel.toggleFilter(filter) }
                        )
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var transfersSection: some View {
        if let viewModel = viewModel {
            VStack(alignment: .leading, spacing: 16) {
                Text("Показывать варианты с пересадками")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.appBlack))

                VStack(spacing: 0) {
                    SelectableRow(
                        title: "Да",
                        isSelected: viewModel.tempIncludeTransfers == true,
                        style: .radio,
                        action: { viewModel.toggleTransfers(true) }
                    )
                    SelectableRow(
                        title: "Нет",
                        isSelected: viewModel.tempIncludeTransfers == false,
                        style: .radio,
                        action: { viewModel.toggleTransfers(false) }
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private var applyButton: some View {
        if let viewModel = viewModel, viewModel.isApplyVisible {
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

    private func applyFilters() {
        guard let viewModel else { return }
        let result = viewModel.applyFilters()
        selectedFilters = result.selectedFilters
        includeTransfers = result.includeTransfers
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
