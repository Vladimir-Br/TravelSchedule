
import Foundation

struct Story: Identifiable {
    let id: Int
    let title: String
    let description: String
    let imageName: String
    var isViewed: Bool = false
}

extension Story {
    static let previewStories: [Story] = [
        Story(
            id: 0,
            title: "Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            imageName: "Story1"
        ),
        Story(
            id: 1,
            title: "Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            imageName: "Story2"
        ),
        Story(
            id: 2,
            title: "Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            imageName: "Story3"
        ),
        Story(
            id: 3,
            title: "Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            imageName: "Story4"
        ),
        Story(
            id: 4,
            title: "Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            imageName: "Story5"
        ),
        Story(
            id: 5,
            title: "Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            imageName: "Story6"
        ),
        Story(
            id: 6,
            title: "Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
            imageName: "Story7"
        )
    ]
}
