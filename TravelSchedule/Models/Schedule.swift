
import Foundation

struct Schedule: Identifiable, Hashable {
    let id: String
    let fromStationCode: String
    let toStationCode: String
    let departureTime: Date
    let arrivalTime: Date
    let carrierTitle: String
    let hasTransfers: Bool
    let transferCity: String?

    var duration: TimeInterval {
        arrivalTime.timeIntervalSince(departureTime)
    }
}
