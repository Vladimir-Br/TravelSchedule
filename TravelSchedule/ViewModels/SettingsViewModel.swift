
import SwiftUI

// MARK: - SettingsViewModel

@Observable
final class SettingsViewModel {
    
    // MARK: - Properties
    
    static let isDarkModeKey = "isDarkMode"
    
    private let userDefaults = UserDefaults.standard
    
    var isDarkMode: Bool {
        didSet {
            userDefaults.set(isDarkMode, forKey: Self.isDarkModeKey)
        }
    }
    
    // MARK: - Computed Properties
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var fullVersion: String {
        "Версия \(appVersion) (beta)"
    }
    
    // MARK: - Initialization
    
    init() {
        self.isDarkMode = userDefaults.bool(forKey: Self.isDarkModeKey)
    }
}
