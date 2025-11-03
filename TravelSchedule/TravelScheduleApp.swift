
import SwiftUI
import UIKit

@main
struct TravelScheduleApp: App {
    
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
                    Image("Schedule")
                        .renderingMode(.template)
                    Text("")
                }
                .tag(0)
                
                NavigationStack {
                    SettingsView()
                }
                .tabItem {
                    Image("Settings")
                        .renderingMode(.template)
                    Text("")
                }
                .tag(1)
            }
            .tint(Color("AppBlack"))
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor(named: "AppWhite")
        
        let offset = UIOffset(horizontal: 0, vertical: 50)
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "AppBlack")
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "AppGray")
        
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.3)
        appearance.shadowImage = UIImage()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
