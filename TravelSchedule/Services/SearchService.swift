
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias SearchResults = Components.Schemas.Segments

protocol SearchServiceProtocol: Sendable {
    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String?,
        lang: String?,
        format: String?,
        transportTypes: String?,
        offset: Int?,
        limit: Int?
    ) async throws -> SearchResults
}

actor SearchService: SearchServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String? = nil,
        lang: String? = "ru_RU",
        format: String? = "json",
        transportTypes: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil
    ) async throws -> SearchResults {
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            format: format,
            lang: lang,
            date: date,
            transport_types: transportTypes,
            offset: offset,
            limit: limit
        ))
        return try response.ok.body.json
    }
}
