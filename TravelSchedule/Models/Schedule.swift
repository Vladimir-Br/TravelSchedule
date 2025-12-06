
import Foundation

struct Schedule: Identifiable, Hashable, Sendable {
    let id: String
    let fromStationCode: String
    let toStationCode: String
    let carrierCode: String?
    let carrierLogo: String?
    let carrierPhone: String?
    let carrierEmail: String?
    let departureTime: Date
    let arrivalTime: Date
    let carrierTitle: String
    let hasTransfers: Bool
    let transferCity: String?

    var duration: TimeInterval {
        arrivalTime.timeIntervalSince(departureTime)
    }
    
    init(
        id: String,
        fromStationCode: String,
        toStationCode: String,
        departureTime: Date,
        arrivalTime: Date,
        carrierTitle: String,
        carrierCode: String? = nil,
        carrierLogo: String? = nil,
        carrierPhone: String? = nil,
        carrierEmail: String? = nil,
        hasTransfers: Bool,
        transferCity: String?
    ) {
        self.id = id
        self.fromStationCode = fromStationCode
        self.toStationCode = toStationCode
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.carrierTitle = carrierTitle
        self.carrierCode = carrierCode
        self.carrierLogo = carrierLogo
        self.carrierPhone = carrierPhone
        self.carrierEmail = carrierEmail
        self.hasTransfers = hasTransfers
        self.transferCity = transferCity
    }
}
