
import Foundation

struct Station: Identifiable, Hashable, Sendable {
    let code: String
    let title: String
    var cityTitle: String? = nil
    
    var id: String { code }
}
