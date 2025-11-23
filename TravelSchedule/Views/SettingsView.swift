
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
        Toggle("Темная тема", isOn: isDarkMode)
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(Color(.appBlack))
            .tracking(-0.41)
            .tint(Color(.appBlue))
            .frame(minHeight: 60)
            .padding(.horizontal, 16)
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
            mainContent
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
        }
        .background(Color(.appWhite))
        .navigationTitle("Пользовательское соглашение")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
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
    
    // MARK: - Views
    
    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум для физических лиц")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.appBlack))
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            
            Text(text1)
                .font(.system(size: 17))
                .tracking(-0.41)
                .foregroundColor(Color(.appBlack))
                .fixedSize(horizontal: false, vertical: true)
            
            Text("1. ТЕРМИНЫ")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.appBlack))
                .padding(.top, 16)
            
            Text(text2)
                .font(.system(size: 17))
                .tracking(-0.41)
                .foregroundColor(Color(.appBlack))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Content
    
    private var text1: String {
        """
        Данный документ является действующим, если расположен по адресу: https://yandex.ru/legal/practicum_offer
        
        Российская Федерация, город Москва
        """
    }
    
    private var text2: String {
        """
        Понятия, используемые в Оферте, означают следующее:
        
        Авторизованные адреса — адреса электронной почты каждой Стороны. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.
        
        Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения, который предоставляется Студенту единожды при регистрации на Сервисе на безвозмездной основе. В процессе обучения в рамках Вводного курса Студенту предоставляется возможность ознакомления с работой Сервиса и определения возможности Студента продолжить обучение в рамках Полного курса по выбранной Студентом Программе обучения. Точное количество часов обучения в рамках Вводного курса зависит от выбранной Студентом Профессии или Курса и определяется в Программе обучения, размещенной на Сервисе. Максимальный срок освоения Вводного курса составляет 1 (один) год с даты начала обучения.
        """
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
