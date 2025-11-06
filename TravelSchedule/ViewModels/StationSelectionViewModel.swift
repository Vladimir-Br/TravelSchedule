
import Foundation

@Observable
final class StationSelectionViewModel {
    var searchQuery: String = ""
    let city: City
    
    init(city: City) {
        self.city = city
    }
    
    var filteredStations: [Station] {
        MockData.searchStations(query: searchQuery, cityCode: city.code)
    }
}
