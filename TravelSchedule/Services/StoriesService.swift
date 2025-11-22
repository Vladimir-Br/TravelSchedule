
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - StoriesServiceProtocol

protocol StoriesServiceProtocol {
    func getStories() async throws -> [Story]
    func markStoryAsViewed(id: Int) async throws
}

// MARK: - StoriesService

final class StoriesService: StoriesServiceProtocol {
    
    // MARK: - Properties
    
    private let client: Client
    private let apikey: String
    
    // MARK: - Initializer
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    // MARK: - Public Methods
    
    func getStories() async throws -> [Story] {
        // TODO: Реализовать загрузку из API, когда будет готов endpoint
        // Пока возвращаем статические данные
        return Story.previewStories
    }
    
    func markStoryAsViewed(id: Int) async throws {
        // TODO: Отправить на сервер, когда будет готов endpoint
    }
}
