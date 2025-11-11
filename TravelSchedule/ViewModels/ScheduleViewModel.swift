
import Foundation

enum DepartureFilter: CaseIterable, Hashable {
    case morning
    case afternoon
    case evening
    case night

    var title: String {
        switch self {
        case .morning:
            return "Утро 06:00 - 12:00"
        case .afternoon:
            return "День 12:00 - 18:00"
        case .evening:
            return "Вечер 18:00 - 00:00"
        case .night:
            return "Ночь 00:00 - 06:00"
        }
    }

    var hourRange: Range<Int> {
        switch self {
        case .morning:
            return 6..<12
        case .afternoon:
            return 12..<18
        case .evening:
            return 18..<24
        case .night:
            return 0..<6
        }
    }
}

@Observable
final class ScheduleViewModel {
    let fromStation: Station
    let toStation: Station

    private(set) var schedules: [Schedule] = []

    var selectedDepartureFilters: Set<DepartureFilter> = [] {
        didSet {
            applyFilters()
        }
    }

    var includeTransfers: Bool? = nil {
        didSet {
            applyFilters()
        }
    }

    private(set) var filteredSchedules: [Schedule] = []

    private let calendar = Calendar.current

    init(fromStation: Station, toStation: Station) {
        self.fromStation = fromStation
        self.toStation = toStation
        loadSchedules()
    }

    func loadSchedules() {
        schedules = MockData.getSchedules(
            from: fromStation.code,
            to: toStation.code
        )
        applyFilters()
    }

    private func applyFilters() {
        filteredSchedules = schedules.filter { schedule in
            passesTransfersFilter(schedule) &&
            passesDepartureFilter(schedule)
        }
    }

    private func passesTransfersFilter(_ schedule: Schedule) -> Bool {
        guard let includeTransfers else { return true }
        return includeTransfers || !schedule.hasTransfers
    }

    private func passesDepartureFilter(_ schedule: Schedule) -> Bool {
        guard !selectedDepartureFilters.isEmpty else { return true }

        let hour = calendar.component(.hour, from: schedule.departureTime)
        return selectedDepartureFilters.contains { $0.hourRange.contains(hour) }
    }
}
