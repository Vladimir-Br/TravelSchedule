
import SwiftUI

// MARK: - StoriesView

struct StoriesView: View {
    let stories: [Story]
    let onStoryTap: (Int) -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(Array(stories.enumerated()), id: \.offset) { index, story in
                    StoryCardView(story: story, onTap: { onStoryTap(index) })
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    StoriesView(stories: Story.previewStories, onStoryTap: { _ in })
        .preferredColorScheme(.light)
}

