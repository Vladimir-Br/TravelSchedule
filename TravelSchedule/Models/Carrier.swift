
import Foundation

struct Carrier: Identifiable, Hashable {
    let id: String
    let code: String
    let title: String
    let website: String?
    let phone: String?
    let email: String?
    let address: String?
    let logo: String?
    
    init(
        code: String,
        title: String,
        website: String? = nil,
        phone: String? = nil,
        email: String? = nil,
        address: String? = nil,
        logo: String? = nil
    ) {
        self.id = code
        self.code = code
        self.title = title
        self.website = website
        self.phone = phone
        self.email = email
        self.address = address
        self.logo = logo
    }
}
