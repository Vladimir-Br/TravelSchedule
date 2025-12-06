
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

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
    private(set) var errorType: ErrorType?
    
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
        do {
            let service = try resolveService()
            try await fetchSchedules(service: service, date: currentDateString())
        } catch {
            await handleSearchError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func resolveService() throws -> SearchServiceProtocol {
        if let searchService {
            return searchService
        }
        
        return SearchService(
            client: Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            ),
            apikey: APIKeys.yandexApiKey
        )
    }
    
    private func fetchSchedules(
        service: SearchServiceProtocol,
        date: String?
    ) async throws {
        let response = try await service.getScheduleBetweenStations(
            from: fromStation.code,
            to: toStation.code,
            date: date,
            lang: "ru_RU",
            format: "json",
            transportTypes: nil,
            offset: nil,
            limit: nil
        )
        schedules = mapSchedules(from: response)
        applyFilters()
        errorType = nil
    }
    
    private func handleSearchError(_ error: Error) async {
        let description = String(describing: error)

        if description.contains("statusCode: 404") {
            do {
                let service = try resolveService()
                try await fetchSchedules(service: service, date: nil)
            } catch {
                schedules = []
                filteredSchedules = []
                errorType = nil
            }
            return
        }
        
        errorType = mapError(error)
        schedules = []
        filteredSchedules = []
    }
    
    private func currentDateString() -> String {
        DateFormatter.scheduleDate.string(from: Date())
    }
    
    private func mapSchedules(from response: SearchResults) -> [Schedule] {
        let segments = response.segments ?? []
        var result: [Schedule] = []
        
        for segment in segments {
            guard
                let fromCode = segment.from?.code ?? segment.from?.codes?.`yandex_code`,
                let toCode = segment.to?.code ?? segment.to?.codes?.`yandex_code`,
                let departureDate = parseDate(segment.departure),
                let arrivalDate = parseDate(segment.arrival)
            else {
                continue
            }
            
            let departureKey = segment.departure ?? UUID().uuidString
            let id = (segment.thread?.uid ?? "segment") + "_" + departureKey
            
            let carrier = segment.thread?.carrier
            let carrierTitle = carrier?.title ?? segment.thread?.title ?? "Перевозчик"
            let carrierYandexCode = carrier?.code.map { String($0) }
            let carrierLogo = carrier?.logo
            let carrierPhone = carrier?.phone
            let carrierEmail = carrier?.email
            
            let schedule = Schedule(
                id: id,
                fromStationCode: fromCode,
                toStationCode: toCode,
                departureTime: departureDate,
                arrivalTime: arrivalDate,
                carrierTitle: carrierTitle,
                carrierCode: carrierYandexCode,
                carrierLogo: carrierLogo,
                carrierPhone: carrierPhone,
                carrierEmail: carrierEmail,
                hasTransfers: false,
                transferCity: nil
            )
            result.append(schedule)
        }
        
        return result
    }
    
    private func parseDate(_ dateString: String?) -> Date? {
        guard let dateString else { return nil }
        
        let withFraction = ISO8601DateFormatter.makeWithFraction()
        if let date = withFraction.date(from: dateString) {
            return date
        }
        
        let noFraction = ISO8601DateFormatter.makeNoFraction()
        return noFraction.date(from: dateString)
    }
    
    private func mapError(_ error: Error) -> ErrorType {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            return .noInternet
        }
        return .serverError
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

// MARK: - Cached Formatters

private extension DateFormatter {
    static let scheduleDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter
    }()
}

private extension ISO8601DateFormatter {
    static func makeWithFraction() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter
    }
    
    static func makeNoFraction() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }
}
