
import SwiftUI

// MARK: - CarrierCardView

struct CarrierCardView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.appWhite)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
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
                                    value: "i.lozgkina@yandex.ru",
                                    valueColor: Color(.appBlue)
                                )

                                contactField(
                                    label: "Телефон",
                                    value: "+7 (904) 329-27-71",
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

    private var logoView: some View {
        Image("RailwayBigLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 343, height: 104)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var titleView: some View {
        Text("ОАО «РЖД»")
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
        CarrierCardView()
    }
}
