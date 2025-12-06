
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

@MainActor
@Observable
final class StationSelectionViewModel {
    
    // MARK: - Properties
    
    var searchQuery: String = ""
    let city: City
    private(set) var stations: [Station] = []
    private(set) var errorType: ErrorType?
    
    private let allStationsService: AllStationsServiceProtocol?
    
    // MARK: - Computed Properties
    
    var filteredStations: [Station] {
        guard !searchQuery.isEmpty else {
            return stations
        }
        
        let queryLowercased = searchQuery.lowercased()
        return stations.filter { station in
            station.title.lowercased().contains(queryLowercased)
        }
    }
    
    // MARK: - Initialization
    
    init(
        city: City,
        allStationsService: AllStationsServiceProtocol? = nil
    ) {
        self.city = city
        self.allStationsService = allStationsService
    }
    
    // MARK: - Public Methods
    
    func loadStations() async {
        do {
            let service = try resolveService()
            let response = try await service.getAllStations(
                lang: "ru_RU",
                format: "json"
            )
            stations = mapStations(from: response, cityCode: city.code)
            errorType = nil
        } catch {
            errorType = mapError(error)
            stations = []
        }
    }
    
    // MARK: - Private Methods
    
    private func resolveService() throws -> AllStationsServiceProtocol {
        if let allStationsService {
            return allStationsService
        }
        
        return AllStationsService(
            client: Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            ),
            apikey: APIKeys.yandexApiKey
        )
    }
    
    private func mapStations(
        from response: AllStations,
        cityCode: String
    ) -> [Station] {
        let countries = response.countries ?? []
        let regions = countries.flatMap { $0.regions ?? [] }
        let settlements = regions.flatMap { $0.settlements ?? [] }
        let matchingSettlements = settlements.filter { settlement in
            settlement.codes?.`yandex_code` == cityCode
        }
        
        let stations = matchingSettlements.flatMap { settlement in
            settlement.stations ?? []
        }.filter { station in
            station.transport_type?.lowercased() == "train"
        }
        
        var unique: [String: Station] = [:]
        
        for station in stations {
            guard let code = station.code ?? station.codes?.`yandex_code` else {
                continue
            }
            
            let rawTitle = station.title ?? code
            let stationTitle = extractStationName(from: rawTitle)
            
            let mapped = Station(
                code: code,
                title: stationTitle,
                cityTitle: matchingSettlements.first?.title
            )
            unique[code] = mapped
        }
        
        return Array(unique.values).sorted { $0.title < $1.title }
    }
    
    private func extractStationName(from title: String) -> String {
        guard let openParen = title.firstIndex(of: "("),
              let closeParen = title.lastIndex(of: ")"),
              openParen < closeParen else {
            return title
        }
        
        let startIndex = title.index(after: openParen)
        return String(title[startIndex..<closeParen])
    }
    
    private func mapError(_ error: Error) -> ErrorType {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            return .noInternet
        }
        return .serverError
    }
}
