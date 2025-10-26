
import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testFetchStations()
            testFetchCopyright()
            testFetchSchedule()
            testFetchStationSchedule()
            testFetchRouteStations()
            testFetchNearestCity()
            testFetchCarrierInfo()
            testFetchAllStations()
        }
    }
    
    func createClient() throws -> Client {
        return Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )
    }
}

func createClient() throws -> Client {
    return Client(
        serverURL: try Servers.Server1.url(),
        transport: URLSessionTransport()
    )
}

func testFetchStations() {
    Task {
        do {
            let client = try createClient()
            let service = NearestStationsService(
                client: client,
                apikey: APIKeys.yandexApiKey
            )
            
            print("Получение ближайших станций...")
            let _ = try await service.getNearestStations(
                lat: 59.864177,
                lng: 30.319163,
                distance: 50
            )
            
            print("Успешно получены станции")
        } catch {
            print("Ошибка получения станций: \(error)")
        }
    }
}

func testFetchCopyright() {
    Task {
        do {
            let client = try createClient()
            let service = CopyrightService(
                client: client,
                apikey: APIKeys.yandexApiKey
            )
            
            print("Получение информации о копирайте...")
            let _ = try await service.getCopyright()
            
            print("Успешно получена информация о копирайте")
        } catch {
            print("Ошибка получения копирайта: \(error)")
        }
    }
}

func testFetchSchedule() {
    Task {
        do {
            let client = try createClient()
            let service = SearchService(
                client: client,
                apikey: APIKeys.yandexApiKey
            )

            print("Получение расписания между станциями...")
            let _ = try await service.getScheduleBetweenStations(
                from: "s9813094",
                to: "s9857049"
            )
            
            print("Успешно получено расписание")
        } catch {
            print("Ошибка получения расписания: \(error)")
        }
    }
}

func testFetchStationSchedule() {
    Task {
        do {
            let client = try createClient()
            let service = ScheduleService(
                client: client,
                apikey: APIKeys.yandexApiKey
            )

            print("Получение расписания станции...")
            let _ = try await service.getStationSchedule(
                station: "s9603500"
            )

            print("Успешно получено расписание станции")
        } catch {
            print("Ошибка получения расписания станции: \(error)")
        }
    }
}

func testFetchRouteStations() {
    Task {
        do {
            let client = try createClient()
            let service = ThreadService(
                client: client,
                apikey: APIKeys.yandexApiKey
            )

            print("Получение станций маршрута...")
            let _ = try await service.getRouteStations(
                uid: "6595_0_9602498_g25_4",
                from: "s9603500",
                to: "s9603435",
                format: "json",
                lang: "ru_RU"
            )
            
            print("Успешно получены станции маршрута")
        } catch {
            print("Ошибка получения станций маршрута: \(error)")
        }
    }
}

func testFetchNearestCity() {
    Task {
        do {
            let client = try createClient()
            let service = NearestCityService(
                client: client,
                apikey: APIKeys.yandexApiKey
            )

            print("Получение ближайшего города...")
            let _ = try await service.getNearestCity(
                lat: 59.864177,
                lng: 30.310988,
                distance: 50,
                lang: "ru_RU",
                format: "json"
            )
            
            print("Успешно получен ближайший город")
        } catch {
            print("Ошибка получения ближайшего города: \(error)")
        }
    }
}

func testFetchCarrierInfo() {
    Task {
        do {
            let client = try createClient()
            let service = CarrierService(
                client: client,
                apikey: APIKeys.yandexApiKey
            )

            print("Получение информации о перевозчике...")
            let _ = try await service.getCarrierInfo(
                code: "SU",
                system: "iata",
                lang: "ru_RU",
                format: "json"
            )

            print("Успешно получена информация о перевозчике")
        } catch {
            print("Ошибка получения информации о перевозчике: \(error)")
        }
    }
}

func testFetchAllStations() {
    Task {
        do {
            let client = try createClient()
            let service = AllStationsService(
                client: client,
                apikey: APIKeys.yandexApiKey
            )

            print("Получение всех станций...")
            let _ = try await service.getAllStations(
                lang: "ru_RU",
                format: "json"
            )

            print("Успешно получены все станции")
        } catch {
            print("Ошибка получения всех станций: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
