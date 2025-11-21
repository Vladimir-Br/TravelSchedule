
import SwiftUI
import UIKit

@main
struct TravelScheduleApp: App {
    @State private var settingsViewModel = SettingsViewModel()
    
    init() {
        setupTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    MainView()
                }
                .tabItem {
                    Image(.schedule)
                        .renderingMode(.template)
                    Text("")
                }
                .tag(0)
                
                NavigationStack {
                    SettingsView(viewModel: settingsViewModel)
                }
                .tabItem {
                    Image(.settings)
                        .renderingMode(.template)
                    Text("")
                }
                .tag(1)
            }
            .tint(Color(.appBlack))
            .preferredColorScheme(settingsViewModel.isDarkMode ? .dark : .light)
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor(resource: .appWhite)
        
        let offset = UIOffset(horizontal: 0, vertical: 50)
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(resource: .appBlack)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(resource: .appGray)
        
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.3)
        appearance.shadowImage = UIImage()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
