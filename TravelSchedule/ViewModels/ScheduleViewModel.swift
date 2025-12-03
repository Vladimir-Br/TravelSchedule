
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

@MainActor
@Observable
final class ScheduleViewModel {
    
    // MARK: - Properties
    
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
    private let searchService: SearchServiceProtocol?
    
    // MARK: - Initialization
    
    init(
        fromStation: Station,
        toStation: Station,
        searchService: SearchServiceProtocol? = nil
    ) {
        self.fromStation = fromStation
        self.toStation = toStation
        self.searchService = searchService
    }
    
    // MARK: - Public Methods
    
    func loadSchedules() async {
        guard searchService != nil else {
            // Если сервис не передан, используем мок-данные
            loadMockSchedules()
            return
        }
        
        // TODO: Реализовать загрузку из API, когда будет готово
        // Пока используем мок-данные
        loadMockSchedules()
    }
    
    // MARK: - Private Methods
    
    private func loadMockSchedules() {
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
