import SwiftUI
import Combine

// MARK: - StoriesFullScreenViewModel

@MainActor
@Observable
final class StoriesFullScreenViewModel {
    
    // MARK: - Properties
    
    var isLoading: Bool = false
    var error: Error?
    var stories: [Story] = []
    var currentIndex: Int = 0 {
        didSet {
            if oldValue != currentIndex && stories.indices.contains(oldValue) {
                markAsViewed(index: oldValue)
            }
            updateProgress()
        }
    }
    var progress: CGFloat = 0
    var shouldDismiss: Bool = false
    
    private var timer: AnyCancellable?
    private let storiesService: StoriesServiceProtocol?
    private let onStoriesUpdated: ([Story]) -> Void
    
    private let secondsPerStory: TimeInterval = 10
    private let tick: TimeInterval = 0.05
    
    private var progressPerTick: CGFloat {
        guard !stories.isEmpty else { return 0 }
        return CGFloat(1.0) / CGFloat(stories.count) / CGFloat(secondsPerStory) * CGFloat(tick)
    }
    
    // MARK: - Initializer
    
    init(
        storiesService: StoriesServiceProtocol? = nil,
        initialStories: [Story] = [],
        startIndex: Int = 0,
        onStoriesUpdated: @escaping ([Story]) -> Void
    ) {
        self.storiesService = storiesService
        self.onStoriesUpdated = onStoriesUpdated
        self.stories = initialStories.isEmpty ? Story.previewStories : initialStories
        self.currentIndex = startIndex
        updateProgress()
    }
    
    // MARK: - Public Methods - Data Loading
    
    func loadStories() async {
        guard let service = storiesService else {
            ensureStoriesNotEmpty()
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            stories = try await service.getStories()
            updateProgress()
        } catch {
            self.error = error
            ensureStoriesNotEmpty()
        }
        
        isLoading = false
    }
    
    // MARK: - Public Methods - Timer
    
    func startTimer() {
        guard !isLoading, error == nil, !stories.isEmpty else { return }
        
        timer?.cancel()
        updateProgress()
        
        timer = Timer.publish(every: tick, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timerTick()
            }
    }
    
    func stopTimer() {
        timer?.cancel()
    }
    
    // MARK: - Public Methods - Navigation
    
    func nextStory() {
        guard currentIndex < stories.count - 1 else {
            finishViewing()
            return
        }
        currentIndex += 1
    }
    
    func previousStory() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }
    
    // MARK: - Private Methods - Timer Logic
    
    private func timerTick() {
        let end = sectionEnd()
        let next = progress + progressPerTick
        
        guard next < end else {
            nextStory()
            return
        }
        
        withAnimation(.linear(duration: tick)) {
            progress = next
        }
    }
    
    private func updateProgress() {
        withAnimation {
            progress = sectionStart()
        }
    }
    
    // MARK: - Private Methods - Helpers
    
    private func sectionStart() -> CGFloat {
        guard !stories.isEmpty else { return 0 }
        return CGFloat(currentIndex) / CGFloat(stories.count)
    }
    
    private func sectionEnd() -> CGFloat {
        guard !stories.isEmpty else { return 1 }
        return CGFloat(currentIndex + 1) / CGFloat(stories.count)
    }
    
    private func markAsViewed(index: Int) {
        guard stories.indices.contains(index) else { return }
        
        stories[index].isViewed = true
        
        guard let service = storiesService else { return }
        
        Task {
            try? await service.markStoryAsViewed(id: stories[index].id)
        }
    }
    
    private func ensureStoriesNotEmpty() {
        guard stories.isEmpty else { return }
        stories = Story.previewStories
    }
    
    func finishViewing() {
        stopTimer()
        onStoriesUpdated(stories)
        shouldDismiss = true
    }
}
