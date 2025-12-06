
import Foundation

struct Station: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let code: String
    let cityTitle: String?
    
    init(
        code: String,
        title: String,
        cityTitle: String? = nil
    ) {
        self.id = code
        self.code = code
        self.title = title
        self.cityTitle = cityTitle
    }
}
