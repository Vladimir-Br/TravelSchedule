
import Foundation

struct Story: Identifiable {
    let id: Int
    let title: String
    let description: String
    let imageName: String
    var isViewed: Bool = false
}
