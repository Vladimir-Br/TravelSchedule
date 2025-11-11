
import Foundation

struct City: Identifiable, Hashable {
    let id: String
    let title: String
    let code: String
    
    init(code: String, title: String) {
        self.id = code
        self.code = code
        self.title = title
    }
}
