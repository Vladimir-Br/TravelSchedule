
import Foundation

// MARK: - Mock Data

struct MockData {
    
    // MARK: - Cities Data
    
    static let allCities: [City] = [
        City(code: "MSK", title: "Москва"),
        City(code: "SPB", title: "Санкт-Петербург"),
        City(code: "NSK", title: "Новосибирск"),
        City(code: "EKB", title: "Екатеринбург"),
        City(code: "KZN", title: "Казань")
    ]
    
    // MARK: - Stations Data
    
    static let allStations: [Station] = [
        // Москва
        Station(code: "MSK_LEN", title: "Ленинградский вокзал"),
        Station(code: "MSK_YAR", title: "Ярославский вокзал"),
        Station(code: "MSK_KAZ", title: "Казанский вокзал"),
        Station(code: "MSK_KUR", title: "Курский вокзал"),
        Station(code: "MSK_KIE", title: "Киевский вокзал"),
        Station(code: "MSK_PAV", title: "Павелецкий вокзал"),
        Station(code: "MSK_BEL", title: "Белорусский вокзал"),
        Station(code: "MSK_SAV", title: "Савёловский вокзал"),
        Station(code: "MSK_RIZ", title: "Рижский вокзал"),
        Station(code: "MSK_VOS", title: "Восточный вокзал"),
        
        // Санкт-Петербург
        Station(code: "SPB_MOS", title: "Московский вокзал"),
        Station(code: "SPB_FIN", title: "Финляндский вокзал"),
        Station(code: "SPB_VIT", title: "Витебский вокзал"),
        Station(code: "SPB_LAD", title: "Ладожский вокзал"),
        Station(code: "SPB_BAL", title: "Балтийский вокзал"),
        
        // Новосибирск
        Station(code: "NSK_GLA", title: "Новосибирск-Главный"),
        Station(code: "NSK_ZAP", title: "Новосибирск-Западный"),
        Station(code: "NSK_YUG", title: "Новосибирск-Южный"),
        Station(code: "NSK_INS", title: "Инская"),
        Station(code: "NSK_OB", title: "Обь"),
        
        // Екатеринбург
        Station(code: "EKB_PAS", title: "Екатеринбург-Пассажирский"),
        Station(code: "EKB_STA", title: "Старый вокзал (музейный комплекс)"),
        Station(code: "EKB_SHU", title: "Станция Шувакиш"),
        
        // Казань
        Station(code: "KZN_1", title: "Казань-1 (Главный)"),
        Station(code: "KZN_2", title: "Казань-2"),
        Station(code: "KZN_KOM", title: "Компрессорный"),
        Station(code: "KZN_YUD", title: "Юдино"),
        Station(code: "KZN_VOS", title: "Восстание-Пассажирская")
    ]
    
    // MARK: - Schedules Data
    
    static let allSchedules: [Schedule] = [
        // Санкт-Петербург (Московский вокзал) → Москва (Ленинградский вокзал)
        Schedule(
            id: "S1",
            fromStationCode: "SPB_MOS",
            toStationCode: "MSK_LEN",
            departureTime: makeDate(hour: 6, minute: 0),
            arrivalTime: makeDate(hour: 9, minute: 30),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S2",
            fromStationCode: "SPB_MOS",
            toStationCode: "MSK_LEN",
            departureTime: makeDate(hour: 7, minute: 30),
            arrivalTime: makeDate(hour: 15, minute: 30),
            carrierTitle: "РЖД",
            hasTransfers: true,
            transferCity: "Костроме"
        ),
        Schedule(
            id: "S3",
            fromStationCode: "SPB_MOS",
            toStationCode: "MSK_LEN",
            departureTime: makeDate(hour: 11, minute: 45),
            arrivalTime: makeDate(hour: 15, minute: 15),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S4",
            fromStationCode: "SPB_MOS",
            toStationCode: "MSK_LEN",
            departureTime: makeDate(hour: 13, minute: 30),
            arrivalTime: makeDate(hour: 17, minute: 0),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S5",
            fromStationCode: "SPB_MOS",
            toStationCode: "MSK_LEN",
            departureTime: makeDate(hour: 16, minute: 15),
            arrivalTime: makeDate(hour: 19, minute: 45),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S6",
            fromStationCode: "SPB_MOS",
            toStationCode: "MSK_LEN",
            departureTime: makeDate(hour: 19, minute: 40),
            arrivalTime: makeDate(hour: 23, minute: 10),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S7",
            fromStationCode: "SPB_MOS",
            toStationCode: "MSK_LEN",
            departureTime: makeDate(hour: 23, minute: 55),
            arrivalTime: makeDate(hour: 8, minute: 5, nextDay: true),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S8",
            fromStationCode: "SPB_MOS",
            toStationCode: "MSK_LEN",
            departureTime: makeDate(hour: 10, minute: 0),
            arrivalTime: makeDate(hour: 14, minute: 30),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        
        // Москва (Ленинградский вокзал) → Санкт-Петербург (Московский вокзал)
        Schedule(
            id: "S9",
            fromStationCode: "MSK_LEN",
            toStationCode: "SPB_MOS",
            departureTime: makeDate(hour: 5, minute: 45),
            arrivalTime: makeDate(hour: 9, minute: 15),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S10",
            fromStationCode: "MSK_LEN",
            toStationCode: "SPB_MOS",
            departureTime: makeDate(hour: 7, minute: 0),
            arrivalTime: makeDate(hour: 14, minute: 50),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S11",
            fromStationCode: "MSK_LEN",
            toStationCode: "SPB_MOS",
            departureTime: makeDate(hour: 12, minute: 30),
            arrivalTime: makeDate(hour: 16, minute: 0),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S12",
            fromStationCode: "MSK_LEN",
            toStationCode: "SPB_MOS",
            departureTime: makeDate(hour: 15, minute: 20),
            arrivalTime: makeDate(hour: 18, minute: 50),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S13",
            fromStationCode: "MSK_LEN",
            toStationCode: "SPB_MOS",
            departureTime: makeDate(hour: 18, minute: 15),
            arrivalTime: makeDate(hour: 21, minute: 45),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S14",
            fromStationCode: "MSK_LEN",
            toStationCode: "SPB_MOS",
            departureTime: makeDate(hour: 20, minute: 30),
            arrivalTime: makeDate(hour: 0, minute: 0, nextDay: true),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S15",
            fromStationCode: "MSK_LEN",
            toStationCode: "SPB_MOS",
            departureTime: makeDate(hour: 1, minute: 10),
            arrivalTime: makeDate(hour: 9, minute: 20),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        ),
        Schedule(
            id: "S16",
            fromStationCode: "MSK_LEN",
            toStationCode: "SPB_MOS",
            departureTime: makeDate(hour: 14, minute: 0),
            arrivalTime: makeDate(hour: 18, minute: 30),
            carrierTitle: "РЖД",
            hasTransfers: false,
            transferCity: nil
        )
    ]

    // MARK: - Station to City Mapping
    
    private static let stationToCityMapping: [String: String] = [
        // Москва
        "MSK_LEN": "MSK", "MSK_YAR": "MSK", "MSK_KAZ": "MSK", "MSK_KUR": "MSK",
        "MSK_KIE": "MSK", "MSK_PAV": "MSK", "MSK_BEL": "MSK", "MSK_SAV": "MSK",
        "MSK_RIZ": "MSK", "MSK_VOS": "MSK",
        
        // Санкт-Петербург
        "SPB_MOS": "SPB", "SPB_FIN": "SPB", "SPB_VIT": "SPB", "SPB_LAD": "SPB",
        "SPB_BAL": "SPB",
        
        // Новосибирск
        "NSK_GLA": "NSK", "NSK_ZAP": "NSK", "NSK_YUG": "NSK", "NSK_INS": "NSK",
        "NSK_OB": "NSK",
        
        // Екатеринбург
        "EKB_PAS": "EKB", "EKB_STA": "EKB", "EKB_SHU": "EKB",
        
        // Казань
        "KZN_1": "KZN", "KZN_2": "KZN", "KZN_KOM": "KZN", "KZN_YUD": "KZN",
        "KZN_VOS": "KZN"
    ]
    
    // MARK: - Carriers Data
    
    static let allCarriers: [Carrier] = [
        Carrier(
            code: "RZD",
            title: "РЖД",
            website: "https://www.rzd.ru",
            phone: "+7 (800) 775-00-00",
            email: "info@rzd.ru",
            address: "Москва, ул. Новая Басманная, д. 2",
            logo: nil
        ),
        Carrier(
            code: "FGK",
            title: "ФГК",
            website: "https://www.fgk.ru",
            phone: "+7 (495) 788-88-88",
            email: "info@fgk.ru",
            address: "Москва, ул. Красная площадь, д. 1",
            logo: nil
        ),
        Carrier(
            code: "URAL",
            title: "Урал логистика",
            website: "https://www.ural-logistika.ru",
            phone: "+7 (343) 345-67-89",
            email: "info@ural-logistika.ru",
            address: "Екатеринбург, ул. Ленина, д. 50",
            logo: nil
        ),
        Carrier(
            code: "S7",
            title: "S7 Airlines",
            website: "https://www.s7.ru",
            phone: "+7 (495) 777-77-77",
            email: "info@s7.ru",
            address: "Москва, Ходынский бульвар, д. 1",
            logo: nil
        ),
        Carrier(
            code: "AEROFLOT",
            title: "Аэрофлот",
            website: "https://www.aeroflot.ru",
            phone: "+7 (495) 223-55-55",
            email: "info@aeroflot.ru",
            address: "Москва, Ленинградский проспект, д. 37",
            logo: nil
        )
    ]
    
    // MARK: - Public Functions
    
    static func getAllCities() -> [City] {
        return allCities
    }
    
    static func getStations(for cityCode: String) -> [Station] {
        return allStations.filter { station in
            stationToCityMapping[station.code] == cityCode
        }
    }
    
    static func searchCities(query: String) -> [City] {
        guard !query.isEmpty else {
            return getAllCities()
        }
        
        let lowercasedQuery = query.lowercased()
        return allCities.filter { city in
            city.title.lowercased().contains(lowercasedQuery)
        }
    }
    
    static func searchStations(query: String, cityCode: String? = nil) -> [Station] {
        let queryLowercased = query.lowercased()
        
        var stations = allStations
        
        if let cityCode = cityCode {
            stations = stations.filter { station in
                stationToCityMapping[station.code] == cityCode
            }
        }
        
        guard !query.isEmpty else {
            return stations
        }
       
        return stations.filter { station in
            station.title.lowercased().contains(queryLowercased)
        }
    }
    
    static func getAllCarriers() -> [Carrier] {
        return allCarriers
    }
    
    static func getCarrier(by code: String) -> Carrier? {
        return allCarriers.first { $0.code == code }
    }
    
    static func getCity(for stationCode: String) -> City? {
        guard let cityCode = stationToCityMapping[stationCode] else {
            return nil
        }
        return allCities.first { $0.code == cityCode }
    }
    
    static func searchCarriers(query: String) -> [Carrier] {
        guard !query.isEmpty else {
            return getAllCarriers()
        }
        
        let lowercasedQuery = query.lowercased()
        return allCarriers.filter { carrier in
            carrier.title.lowercased().contains(lowercasedQuery)
        }
    }

    static func getSchedules(from fromStationCode: String, to toStationCode: String) -> [Schedule] {
        allSchedules.filter { schedule in
            schedule.fromStationCode == fromStationCode && schedule.toStationCode == toStationCode
        }
    }

    // MARK: - Helpers

    private static func makeDate(hour: Int, minute: Int, nextDay: Bool = false) -> Date {
        var components = DateComponents()
        components.year = 2025
        components.month = 11
        components.day = nextDay ? 7 : 6
        components.hour = hour
        components.minute = minute
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components) ?? Date()
    }
}
