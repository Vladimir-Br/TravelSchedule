
import SwiftUI

struct CarrierCardView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.appWhite)
                .ignoresSafeArea()

            Text("Будет реализован в следующем спринте")
                .font(.system(size: 17))
                .foregroundColor(Color(.appGray))
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
}

#Preview {
    NavigationStack {
        CarrierCardView()
    }
}
