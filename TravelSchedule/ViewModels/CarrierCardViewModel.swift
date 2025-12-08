
import Foundation

// MARK: - CarrierCardViewModel

@MainActor
@Observable
final class CarrierCardViewModel {
    
    // MARK: - Properties
    
    private(set) var carrier: Carrier
    
    // MARK: - Initialization
    
    init(
        title: String,
        logo: String?,
        phone: String?,
        email: String?
    ) {
        self.carrier = Carrier(
            code: title,
            title: title,
            website: nil,
            phone: phone,
            email: email,
            address: nil,
            logo: logo
        )
    }
}
