
import Foundation

@MainActor
@Observable
final class StationSelectionViewModel {
    
    // MARK: - Properties
    
    var searchQuery: String = ""
    let city: City
    private(set) var stations: [Station] = []
    
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
        guard allStationsService != nil else {
            // Если сервис не передан, используем мок-данные
            loadMockStations()
            return
        }
        
        // TODO: Реализовать загрузку из API, когда будет готово
        // Пока используем мок-данные
        loadMockStations()
    }
    
    // MARK: - Private Methods
    
    private func loadMockStations() {
        stations = MockData.getStations(for: city.code)
    }
}
