
import SwiftUI

// MARK: - CarrierCardView

struct CarrierCardView: View {
    @Environment(\.dismiss) private var dismiss
    private let viewModel: CarrierCardViewModel
    
    init(
        title: String,
        logo: String?,
        phone: String?,
        email: String?
    ) {
        self.viewModel = CarrierCardViewModel(
            title: title,
            logo: logo,
            phone: phone,
            email: email
        )
    }
    
    var body: some View {
        ZStack {
            Color(.appWhite)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: .zero) {
                    VStack(spacing: 16) {
                        logoView
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        
                        VStack(spacing: 16) {
                            titleView
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 4) {
                                contactField(
                                    label: "E-mail",
                                    value: viewModel.carrier.email,
                                    valueColor: Color(.appBlue)
                                )
                                
                                contactField(
                                    label: "Телефон",
                                    value: viewModel.carrier.phone,
                                    valueColor: Color(.appBlue)
                                )
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Информация о перевозчике")
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
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var logoView: some View {
        let logoURL = viewModel.carrier.logo?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color(.appWhite))
            .frame(width: 343, height: 104)
            .overlay {
                if let logoURL,
                   !logoURL.isEmpty,
                   let url = URL(string: logoURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 16)
                        case .empty:
                            Color(.appWhite)
                        case .failure:
                            Color(.appWhite)
                        @unknown default:
                            Color(.appWhite)
                        }
                    }
                } else {
                    Color(.appWhite)
                }
            }
    }
    
    private var titleView: some View {
        Text(viewModel.carrier.title)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(Color(.appBlack))
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func contactField(label: String, value: String?, valueColor: Color) -> some View {
        let displayValue = (value?.isEmpty == false) ? value! : " "
        let textColor = (value?.isEmpty == false) ? valueColor : Color(.appWhite)
        
        return HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: -4) {
                Text(label)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(.appBlack))
                    .tracking(-0.41)
                    .frame(height: 22, alignment: .leading)

                Text(displayValue)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(textColor)
                    .tracking(0.4)
                    .frame(height: 18, alignment: .leading)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(width: 315)
            .frame(height: 60)
            .padding(.leading, 16)

            Spacer()
        }
        .frame(height: 60)
        .background(Color(.appWhite))
    }
}

#Preview {
    NavigationStack {
        CarrierCardView(
            title: "РЖД",
            logo: nil,
            phone: "+7 (495) 123-45-67",
            email: "info@rzd.ru"
        )
    }
}
