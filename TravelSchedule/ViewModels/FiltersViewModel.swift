
import Foundation

@Observable
final class FiltersViewModel {
    // MARK: - Properties
    
    var tempIncludeTransfers: Bool?
    var tempSelectedFilters: Set<DepartureFilter> = []
    
    // MARK: - Computed Properties
    
    var isApplyVisible: Bool {
        tempIncludeTransfers != nil || !tempSelectedFilters.isEmpty
    }
    
    // MARK: - Initialization
    
    init(
        includeTransfers: Bool?,
        selectedFilters: Set<DepartureFilter>
    ) {
        self.tempIncludeTransfers = includeTransfers
        self.tempSelectedFilters = selectedFilters
    }
    
    // MARK: - Methods
    
    func toggleFilter(_ filter: DepartureFilter) {
        guard tempSelectedFilters.contains(filter) else {
            tempSelectedFilters.insert(filter)
            return
        }
        tempSelectedFilters.remove(filter)
    }
    
    func toggleTransfers(_ value: Bool) {
        guard tempIncludeTransfers == value else {
            tempIncludeTransfers = value
            return
        }
        tempIncludeTransfers = nil
    }
    
    func applyFilters() -> (includeTransfers: Bool?, selectedFilters: Set<DepartureFilter>) {
        return (tempIncludeTransfers, tempSelectedFilters)
    }
}
