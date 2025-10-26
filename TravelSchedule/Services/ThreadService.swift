
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias ThreadStations = Components.Schemas.ThreadStationsResponse

protocol ThreadServiceProtocol {
    func getRouteStations(
        uid: String,
        from: String?,
        to: String?,
        format: String?,
        lang: String?,
        date: String?,
        show_systems: String?
    ) async throws -> ThreadStations
}

final class ThreadService: ThreadServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getRouteStations(
        uid: String,
        from: String? = nil,
        to: String? = nil,
        format: String? = nil,
        lang: String? = nil,
        date: String? = nil,
        show_systems: String? = nil
    ) async throws -> ThreadStations {
        let response = try await client.getRouteStations(query: .init(
            apikey: apikey,
            uid: uid,
            from: from,
            to: to,
            format: format,
            lang: lang,
            date: date,
            show_systems: show_systems
        ))
        return try response.ok.body.json
    }
}
