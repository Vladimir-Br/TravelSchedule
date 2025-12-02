
import Foundation
import OpenAPIRuntime

// MARK: - CarrierCardViewModel

@MainActor
@Observable
final class CarrierCardViewModel {
    
    // MARK: - Properties
    
    private(set) var isLoading: Bool = false
    private(set) var error: Error?
    private(set) var carrier: Carrier?
    
    private let carrierCode: String
    private let carrierService: CarrierServiceProtocol?
    
    // MARK: - Initialization
    
    init(
        carrierCode: String,
        carrierService: CarrierServiceProtocol? = nil
    ) {
        self.carrierCode = carrierCode
        self.carrierService = carrierService
    }
    
    // MARK: - Public Methods
    
    func loadCarrier() async {
        guard let service = carrierService else {
            // Если сервис не передан, используем мок-данные
            loadMockCarrier()
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            let carrierInfo = try await service.getCarrierInfo(
                code: carrierCode,
                system: nil,
                lang: "ru_RU",
                format: nil
            )
            carrier = mapToCarrier(carrierInfo)
        } catch {
            self.error = error
            loadMockCarrier()
        }
        
        isLoading = false
    }
    
    // MARK: - Private Methods
    
    private func mapToCarrier(_ carrierInfo: Components.Schemas.CarrierResponse) -> Carrier {
        // TODO: Реализовать маппинг из API модели в локальную модель Carrier
        // Пока возвращаем мок-данные
        return Carrier(
            code: carrierCode,
            title: "ОАО «РЖД»",
            website: nil,
            phone: nil,
            email: nil,
            address: nil,
            logo: nil
        )
    }
    
    private func loadMockCarrier() {
        // Загружаем мок-данные, если API недоступен
        carrier = Carrier(
            code: carrierCode,
            title: "ОАО «РЖД»",
            website: nil,
            phone: "+7 (904) 329-27-71",
            email: "i.lozgkina@yandex.ru",
            address: nil,
            logo: nil
        )
    }
}
