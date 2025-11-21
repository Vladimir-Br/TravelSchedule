
import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    var viewModel: SettingsViewModel
    @State private var showUserAgreement = false
    
    var body: some View {
        @Bindable var vm = viewModel
        
        return NavigationStack {
            ZStack {
                Color(.appWhite)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    settingsList(isDarkMode: $vm.isDarkMode)
                        .padding(.top, 24)
                    
                    Spacer()
                    
                    appInfoSection
                }
            }
            .navigationDestination(isPresented: $showUserAgreement) {
                UserAgreementView()
            }
        }
    }
    
    // MARK: - Subviews
    
    private func settingsList(isDarkMode: Binding<Bool>) -> some View {
        VStack(spacing: 0) {
            darkThemeRow(isDarkMode: isDarkMode)
            userAgreementRow
        }
        .frame(height: 120)
    }
    
    private func darkThemeRow(isDarkMode: Binding<Bool>) -> some View {
        HStack(spacing: 0) {
            VStack {
                Text("Темная тема")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(.appBlack))
                    .tracking(-0.41)
                    .frame(height: 22)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 19)
            }
            .frame(height: 60)
            
            Spacer()
            
            Toggle("", isOn: isDarkMode)
                .tint(Color(.appBlue))
                .padding(.trailing, 16)
        }
        .frame(height: 60)
        .padding(.leading, 16)
        .background(Color(.appWhite))
    }
    
    private var userAgreementRow: some View {
        Button(action: {
            showUserAgreement = true
        }) {
            HStack(spacing: 0) {
                VStack {
                    Text("Пользовательское соглашение")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(.appBlack))
                        .tracking(-0.41)
                        .frame(height: 22)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 19)
                }
                .frame(height: 60)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(.appBlack))
                    .padding(.trailing, 16)
            }
            .frame(height: 60)
            .padding(.leading, 16)
        }
        .buttonStyle(.plain)
        .background(Color(.appWhite))
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            Text("Приложение использует API «Яндекс. Расписания»")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(.appBlack))
                .multilineTextAlignment(.center)
                .tracking(0.4)
            
            Text(viewModel.fullVersion)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(.appBlack))
                .tracking(0.4)
        }
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
    }
}

// MARK: - UserAgreementView

private struct UserAgreementView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Пользовательское соглашение")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.appBlack))
                    .padding(.top, 24)
                
                Text("Будет реализовано в следующем спринте")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(.appGray))
                    .padding(.top, 16)
            }
            .padding(.horizontal, 16)
        }
        .background(Color(.appWhite))
        .navigationTitle("Пользовательское соглашение")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(.appBlack))
                }
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
