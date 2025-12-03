
import Foundation

@MainActor
@Observable
final class MainViewModel {
    
    // MARK: - Properties
    
    var fromStation: Station?
    var toStation: Station?
    
    private(set) var stories: [Story] = []
    var selectedStoryIndex: Int = 0
    var isStoriesPresented: Bool = false
    
    private let storiesService: StoriesServiceProtocol?
    
    // MARK: - Computed Properties
    
    var isFindButtonEnabled: Bool {
        fromStation != nil && toStation != nil
    }
    
    // MARK: - Initialization
    
    init(storiesService: StoriesServiceProtocol? = nil) {
        self.storiesService = storiesService
    }
    
    // MARK: - Public Methods
    
    func loadStories() async {
        guard let service = storiesService else {
            // Если сервис не передан, используем локальные данные
            loadLocalStories()
            return
        }
        
        do {
            stories = try await service.getStories()
        } catch {
            // В случае ошибки используем локальные данные
            loadLocalStories()
        }
    }
    
    func swapStations() {
        let temp = fromStation
        fromStation = toStation
        toStation = temp
    }
    
    func setFromStation(_ station: Station) {
        fromStation = station
    }
    
    func setToStation(_ station: Station) {
        toStation = station
    }
    
    func clearFromStation() {
        fromStation = nil
    }
    
    func clearToStation() {
        toStation = nil
    }
    
    func presentStory(at index: Int) {
        guard stories.indices.contains(index) else { return }
        selectedStoryIndex = index
        isStoriesPresented = true
    }
    
    func updateStoriesAfterViewing(_ updatedStories: [Story]) {
        stories = updatedStories
    }
    
    func dismissStories() {
        isStoriesPresented = false
    }
    
    // MARK: - Private Methods
    
    private func loadLocalStories() {
        // Загружаем сторис из локальных источников (соответствует ТЗ)
        stories = Story.previewStories
    }
}
