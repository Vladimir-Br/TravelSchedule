
import Foundation

struct Carrier: Identifiable, Hashable, Sendable {
    let code: String
    let title: String
    let website: String?
    let phone: String?
    let email: String?
    let address: String?
    let logo: String?
    
    var id: String { code }
}
