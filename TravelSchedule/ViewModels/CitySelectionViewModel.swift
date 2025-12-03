
import Foundation

@MainActor
@Observable
final class CitySelectionViewModel {
    
    // MARK: - Properties
    
    var searchQuery: String = ""
    private(set) var cities: [City] = []
    
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
        guard allStationsService != nil else {
            // Если сервис не передан, используем мок-данные
            loadMockCities()
            return
        }
        
        // TODO: Реализовать загрузку из API, когда будет готово
        // Пока используем мок-данные
        loadMockCities()
    }
    
    // MARK: - Private Methods
    
    private func loadMockCities() {
        cities = MockData.getAllCities()
    }
}
