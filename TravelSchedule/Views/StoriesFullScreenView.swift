import SwiftUI

// MARK: - StoriesFullScreenView

struct StoriesFullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: StoriesFullScreenViewModel
    
    let stories: [Story]
    let startIndex: Int
    let storiesService: StoriesServiceProtocol?
    let onStoriesUpdated: ([Story]) -> Void
    
    init(
        stories: [Story],
        startIndex: Int,
        storiesService: StoriesServiceProtocol? = nil,
        onStoriesUpdated: @escaping ([Story]) -> Void
    ) {
        self.stories = stories
        self.startIndex = startIndex
        self.storiesService = storiesService
        self.onStoriesUpdated = onStoriesUpdated
        
        _viewModel = State(
            wrappedValue: StoriesFullScreenViewModel(
                storiesService: storiesService,
                initialStories: stories,
                startIndex: startIndex,
                onStoriesUpdated: onStoriesUpdated
            )
        )
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.error {
                errorView(error: error)
            } else {
                storiesContentView
            }
        }
        .task {
            await viewModel.loadStories()
        }
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ProgressView()
                .tint(.white)
        }
    }
    
    private func errorView(error: Error) -> some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Ошибка загрузки")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text(error.localizedDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                Button("Закрыть") {
                    dismissWithUpdate()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color(.appBlue))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
        }
    }
    
    private var storiesContentView: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 7)
                
                ZStack(alignment: .topTrailing) {
                    TabView(selection: $viewModel.currentIndex) {
                        ForEach(Array(viewModel.stories.enumerated()), id: \.offset) { index, story in
                            StoryPage(story: story)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
                        if shouldDismiss {
                            dismissWithUpdate()
                        }
                    }
                    
                    ProgressBar(
                        numberOfSections: viewModel.stories.count,
                        progress: viewModel.progress
                    )
                    .padding(.top, 28)
                    .padding(.horizontal, 12)
                    
                    Button(action: dismissWithUpdate) {
                        Image("CloseButton")
                            .renderingMode(.original)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .padding(3)
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 12)
                }
                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                .contentShape(Rectangle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            let dragDistance = abs(value.translation.width)
                            
                            guard dragDistance < 15 else {
                                guard value.translation.width < 0, viewModel.currentIndex == viewModel.stories.count - 1 else { return }
                                viewModel.nextStory()
                                return
                            }
                            
                            viewModel.nextStory()
                        }
                )
                
                Spacer().frame(height: 17)
            }
        }
        .onAppear {
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
            dismissWithUpdate()
        }
    }
    
    // MARK: - Helpers
    
    private func dismissWithUpdate() {
        onStoriesUpdated(viewModel.stories)
        dismiss()
    }
}

// MARK: - StoryPage

private struct StoryPage: View {
    let story: Story
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Image(story.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(story.title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text(story.description)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white)
                        .tracking(0.4)
                        .lineLimit(3)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

// MARK: - ProgressBar

private struct ProgressBar: View {
    let numberOfSections: Int
    let progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let safeCount = max(numberOfSections, 1)
            let clamped = max(0, min(progress, 1))
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: geometry.size.width, height: 6)
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: 3)
                    .frame(
                        width: min(clamped * geometry.size.width, geometry.size.width),
                        height: 6
                    )
                    .foregroundColor(Color(.appBlue))
            }
            .mask {
                MaskView(numberOfSections: safeCount)
            }
        }
        .frame(height: 46)
    }
}

private struct MaskView: View {
    let numberOfSections: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                MaskFragmentView()
            }
        }
    }
}

private struct MaskFragmentView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .frame(height: 6)
    }
}

#Preview {
    StoriesFullScreenView(
        stories: Story.previewStories,
        startIndex: 0,
        onStoriesUpdated: { _ in }
    )
}
