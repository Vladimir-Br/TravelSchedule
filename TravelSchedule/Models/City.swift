
import Foundation

struct City: Identifiable, Hashable, Sendable {
    let code: String
    let title: String
    
    var id: String { code }
}
