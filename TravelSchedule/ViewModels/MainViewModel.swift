
import Foundation

@Observable
final class MainViewModel {
    var fromStation: Station?
    var toStation: Station?
    
    var isFindButtonEnabled: Bool {
        fromStation != nil && toStation != nil
    }
    
    func swapStations() {
        let temp = fromStation
        fromStation = toStation
        toStation = temp
    }
    
    func setFromStation(_ station: Station) {
        fromStation = station
    }
    
    func setToStation(_ station: Station) {
        toStation = station
    }
    
    func clearFromStation() {
        fromStation = nil
    }
    
    func clearToStation() {
        toStation = nil
    }
}
