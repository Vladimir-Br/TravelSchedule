
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

// MARK: - StoryCardView

private struct StoryCardView: View {
    let story: Story
    let onTap: () -> Void
    @State private var isPressed: Bool = false
    var body: some View {
        Button(action: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onTap()
            }
        }) {
            ZStack(alignment: .bottomLeading) {
                Image(story.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 92, height: 140)
                    .clipped()
                    .opacity(story.isViewed ? 0.5 : 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                story.isViewed ? Color.clear : Color(.appBlue),
                                lineWidth: 4
                            )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
               
                Text(story.description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white)
                    .tracking(0.4)
                    .lineSpacing(0)
                    .lineLimit(3)
                    .frame(width: 76, height: 45, alignment: .bottomLeading)
                    .padding(.leading, 8)
                    .padding(.bottom, 12)   
            }
            .frame(width: 92, height: 140)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        ._onButtonGesture { pressing in
            isPressed = pressing
        } perform: {}
    }
}

#Preview {
    StoriesView(stories: Story.previewStories, onStoryTap: { _ in })
        .preferredColorScheme(.light)
}
