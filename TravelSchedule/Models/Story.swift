
import Foundation

struct Story: Identifiable, Sendable {
    let id: Int
    let title: String
    let description: String
    let imageName: String
    var isViewed: Bool = false
}
