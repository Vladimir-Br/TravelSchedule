
import Foundation

@Observable
final class CitySelectionViewModel {
    var searchQuery: String = ""
    
    var filteredCities: [City] {
        MockData.searchCities(query: searchQuery)
    }
    
    var isEmpty: Bool {
        !searchQuery.isEmpty && filteredCities.isEmpty
    }
}
