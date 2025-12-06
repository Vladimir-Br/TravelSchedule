
import SwiftUI

struct ScheduleCellView: View {
    let schedule: Schedule
    
    private static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        formatter.calendar = calendar
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    private var durationText: String {
        Self.durationFormatter.string(from: schedule.duration) ?? ""
    }
    
    private var dateText: String {
        Self.dateFormatter.string(from: schedule.departureTime)
    }
    
    private let backgroundColor: Color = Color(.appLightGray)
    private let separatorColor: Color = Color(.appGray)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            headerRow
            timelineRow
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .frame(height: 104)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(backgroundColor)
        )
    }
}

// MARK: - Private Views

private extension ScheduleCellView {
    var headerRow: some View {
        HStack(alignment: .top, spacing: 8) {
            carrierLogoView
            
            VStack(alignment: .leading, spacing: 2) {
                Text(schedule.carrierTitle)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.black)
                    .tracking(-0.41)
                
                if schedule.hasTransfers, let transferCity = schedule.transferCity {
                    Text("С пересадкой в \(transferCity)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(.appRed))
                        .tracking(0.4)
                }
            }
            
            Spacer()
            
            Text(dateText)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.black)
                .tracking(0.4)
        }
    }
    
    @ViewBuilder
    var carrierLogoView: some View {
        let logoURL = schedule.carrierLogo?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let logoURL,
           !logoURL.isEmpty,
           let url = URL(string: logoURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .empty, .failure:
                    Color.gray.opacity(0.2)
                @unknown default:
                    Color.gray.opacity(0.2)
                }
            }
            .frame(width: 38, height: 38)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            Color.gray.opacity(0.2)
                .frame(width: 38, height: 38)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    var timelineRow: some View {
        HStack(spacing: 4) {
            Text(schedule.departureTime, format: .dateTime.hour().minute())
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.black)
                .tracking(-0.41)
            
            separator
            
            Text(durationText)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.black)
                .tracking(0.4)
                .fixedSize()
                .multilineTextAlignment(.center)
            
            separator
            
            Text(schedule.arrivalTime, format: .dateTime.hour().minute())
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.black)
                .tracking(-0.41)
        }
    }
    
    var separator: some View {
        Rectangle()
            .fill(separatorColor)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    let departure = Date()
    let arrival = departure.addingTimeInterval(20 * 60 * 60 + 45 * 60)
    
    let schedule = Schedule(
        id: "preview",
        fromStationCode: "SPB_MOS",
        toStationCode: "MSK_LEN",
        departureTime: departure,
        arrivalTime: arrival,
        carrierTitle: "РЖД",
        hasTransfers: true,
        transferCity: "Костроме"
    )
    
    return ScheduleCellView(schedule: schedule)
        .padding()
        .background(Color(.appWhite))
}

// MARK: - Helpers

private extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.locale = Locale(identifier: "ru_RU")
        self.dateFormat = format
    }
}
