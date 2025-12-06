
import Foundation

struct Carrier: Identifiable, Hashable, Sendable {
    let code: String
    let title: String
    var website: String? = nil
    var phone: String? = nil
    var email: String? = nil
    var address: String? = nil
    var logo: String? = nil
    
    var id: String { code }
}
