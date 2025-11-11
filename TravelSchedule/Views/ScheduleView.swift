
import SwiftUI

struct ScheduleView: View {
    @State private var viewModel: ScheduleViewModel
    @State private var isShowingFilters = false
    @Environment(\.dismiss) private var dismiss

    init(fromStation: Station, toStation: Station) {
        _viewModel = State(initialValue: ScheduleViewModel(fromStation: fromStation, toStation: toStation))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                header
                contentView
            }
            .padding(.top, 16)
        }
        .background(Color(.appWhite))
        .safeAreaInset(edge: .bottom) {
            filterButton
        }
        .navigationBarBackButtonHidden(true)
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
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $isShowingFilters) {
            FiltersView(
                includeTransfers: $viewModel.includeTransfers,
                selectedFilters: $viewModel.selectedDepartureFilters
            )
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.filteredSchedules.isEmpty {
            emptyState
        } else {
            scheduleList
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(viewModel.fromStation.displayTitle) → \(viewModel.toStation.displayTitle)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(.appBlack))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    private var scheduleList: some View {
        LazyVStack(spacing: 8) {
            ForEach(viewModel.filteredSchedules) { schedule in
                NavigationLink {
                    CarrierCardView()
                } label: {
                    ScheduleCellView(schedule: schedule)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    private var emptyState: some View {
        VStack {
            Spacer()
            Text("Вариантов нет")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.appBlack))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .frame(minHeight: 471)
    }
}

private extension ScheduleView {
    var hasActiveFilters: Bool {
        !viewModel.selectedDepartureFilters.isEmpty || viewModel.includeTransfers != nil
    }
    
    var filterButton: some View {
        Button(action: {
            isShowingFilters = true
        }) {
            HStack(spacing: 4) {
                Text("Уточнить время")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                
                if hasActiveFilters {
                    Circle()
                        .fill(Color(.appRed))
                        .frame(width: 8, height: 8)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.appBlue))
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .background(Color.clear)
    }
}

private extension Station {
    var displayTitle: String {
        if let city = MockData.getCity(for: code) {
            return "\(city.title) (\(title))"
        }
        return title
    }
}

#Preview {
    NavigationStack {
        ScheduleView(
            fromStation: Station(code: "SPB_MOS", title: "Московский вокзал"),
            toStation: Station(code: "MSK_LEN", title: "Ленинградский вокзал")
        )
    }
}
