
import Foundation

@Observable
final class MainViewModel {
    var fromStation: Station?
    var toStation: Station?
    
    var stories: [Story] = Story.previewStories
    var selectedStoryIndex: Int = 0
    var isStoriesPresented: Bool = false
    
    var isFindButtonEnabled: Bool {
        fromStation != nil && toStation != nil
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
}
