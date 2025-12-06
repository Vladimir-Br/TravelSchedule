
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

@MainActor
@Observable
final class CitySelectionViewModel {
    
    // MARK: - Properties
    
    var searchQuery: String = ""
    private(set) var cities: [City] = []
    private(set) var errorType: ErrorType?
    
    private let allStationsService: AllStationsServiceProtocol?
    
    // MARK: - Computed Properties
    
    var filteredCities: [City] {
        guard !searchQuery.isEmpty else {
            return cities
        }
        
        let lowercasedQuery = searchQuery.lowercased()
        return cities.filter { city in
            city.title.lowercased().contains(lowercasedQuery)
        }
    }
    
    var isEmpty: Bool {
        !searchQuery.isEmpty && filteredCities.isEmpty
    }
    
    // MARK: - Initialization
    
    init(allStationsService: AllStationsServiceProtocol? = nil) {
        self.allStationsService = allStationsService
    }
    
    // MARK: - Public Methods
    
    func loadCities() async {
        do {
            let service = try resolveService()
            let response = try await service.getAllStations(
                lang: "ru_RU",
                format: "json"
            )
            cities = mapCities(from: response)
            errorType = nil
        } catch {
            errorType = mapError(error)
            cities = []
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
    
    private func mapCities(from response: AllStations) -> [City] {
        let countries = (response.countries ?? []).filter { country in
            let code = country.codes?.`yandex_code`?.uppercased()
            return code == "RU" || country.title?.lowercased() == "россия"
        }
        let settlements = countries
            .flatMap { $0.regions ?? [] }
            .flatMap { $0.settlements ?? [] }
        
        var unique: [String: City] = [:]
        
        for settlement in settlements {
            guard let code = settlement.codes?.`yandex_code` else { continue }
            let city = City(code: code, title: settlement.title ?? code)
            unique[code] = city 
        }
        
        return Array(unique.values).sorted { $0.title < $1.title }
    }
    
    private func mapError(_ error: Error) -> ErrorType {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            return .noInternet
        }
        return .serverError
    }
}
