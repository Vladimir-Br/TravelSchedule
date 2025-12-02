
import SwiftUI

// MARK: - CarrierCardView

struct CarrierCardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: CarrierCardViewModel
    
    init(carrierCode: String) {
        _viewModel = State(initialValue: CarrierCardViewModel(carrierCode: carrierCode))
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
                            if let carrier = viewModel.carrier {
                                titleView(carrier: carrier)
                                    .padding(.horizontal, 16)
                                
                                VStack(spacing: 4) {
                                    if let email = carrier.email {
                                        contactField(
                                            label: "E-mail",
                                            value: email,
                                            valueColor: Color(.appBlue)
                                        )
                                    }
                                    
                                    if let phone = carrier.phone {
                                        contactField(
                                            label: "Телефон",
                                            value: phone,
                                            valueColor: Color(.appBlue)
                                        )
                                    }
                                }
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
        .task {
            await viewModel.loadCarrier()
        }
    }
    
    // MARK: - Subviews
    
    private var logoView: some View {
        Image("RailwayBigLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 343, height: 104)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    
    private func titleView(carrier: Carrier) -> some View {
        Text(carrier.title)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(Color(.appBlack))
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func contactField(label: String, value: String, valueColor: Color) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: -4) {
                Text(label)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(.appBlack))
                    .tracking(-0.41)
                    .frame(height: 22, alignment: .leading)

                Text(value)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(valueColor)
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
        CarrierCardView(carrierCode: "RZD")
    }
}
