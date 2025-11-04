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
    
    /// Возвращает все города
    static func getAllCities() -> [City] {
        return allCities
    }
    
    /// Возвращает станции для указанного города
    static func getStations(for cityCode: String) -> [Station] {
        return allStations.filter { station in
            stationToCityMapping[station.code] == cityCode
        }
    }
    
    /// Поиск городов по запросу (регистронезависимый)
    static func searchCities(query: String) -> [City] {
        guard !query.isEmpty else {
            return getAllCities()
        }
        
        let lowercasedQuery = query.lowercased()
        return allCities.filter { city in
            city.title.lowercased().contains(lowercasedQuery)
        }
    }
    
    /// Поиск станций по запросу
    /// - Parameters:
    ///   - query: Текст поиска
    ///   - cityCode: Опциональный код города для фильтрации (если nil, поиск по всем станциям)
    /// - Returns: Отфильтрованный массив станций
    static func searchStations(query: String, cityCode: String? = nil) -> [Station] {
        let queryLowercased = query.lowercased()
        
        var stations = allStations
        
        // Фильтрация по городу, если указан
        if let cityCode = cityCode {
            stations = stations.filter { station in
                stationToCityMapping[station.code] == cityCode
            }
        }
        
        // Если запрос пустой, возвращаем все станции (с учетом фильтра по городу)
        guard !query.isEmpty else {
            return stations
        }
        
        // Поиск по названию станции
        return stations.filter { station in
            station.title.lowercased().contains(queryLowercased)
        }
    }
    
    /// Возвращает все перевозчики
    static func getAllCarriers() -> [Carrier] {
        return allCarriers
    }
    
    /// Возвращает перевозчика по коду
    static func getCarrier(by code: String) -> Carrier? {
        return allCarriers.first { $0.code == code }
    }
    
    /// Поиск перевозчиков по запросу (регистронезависимый)
    static func searchCarriers(query: String) -> [Carrier] {
        guard !query.isEmpty else {
            return getAllCarriers()
        }
        
        let lowercasedQuery = query.lowercased()
        return allCarriers.filter { carrier in
            carrier.title.lowercased().contains(lowercasedQuery)
        }
    }
}
