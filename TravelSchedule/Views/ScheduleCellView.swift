
import SwiftUI

struct ScheduleCellView: View {
    let schedule: Schedule
    @Environment(\.colorScheme) private var colorScheme
    
    private static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        formatter.calendar = calendar
        return formatter
    }()
    
    private static let timeFormatter = DateFormatter(format: "HH:mm")
    private static let dateFormatter = DateFormatter(format: "d MMMM")
    
    private var durationText: String {
        Self.durationFormatter.string(from: schedule.duration) ?? ""
    }
    
    private var departureTimeText: String {
        Self.timeFormatter.string(from: schedule.departureTime)
    }
    
    private var arrivalTimeText: String {
        Self.timeFormatter.string(from: schedule.arrivalTime)
    }
    
    private var dateText: String {
        Self.dateFormatter.string(from: schedule.departureTime)
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(.appGray) : Color(.appLightGray)
    }

    private var separatorColor: Color {
        colorScheme == .dark ? Color(.appLightGray) : Color(.appGray)
    }

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
            Image(.railway)
                .resizable()
                .frame(width: 38, height: 38)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(schedule.carrierTitle)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(.appBlack))
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
                .foregroundColor(Color(.appBlack))
                .tracking(0.4)
        }
    }
    
    var timelineRow: some View {
        HStack(spacing: 4) {
            Text(departureTimeText)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(Color(.appBlack))
                .tracking(-0.41)
            
            separator
            
            Text(durationText)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(.appBlack))
                .tracking(0.4)
                .fixedSize()
                .multilineTextAlignment(.center)
            
            separator
            
            Text(arrivalTimeText)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(Color(.appBlack))
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
