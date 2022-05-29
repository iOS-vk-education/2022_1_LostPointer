import Foundation

final class Helpers {
    static func convertSecondsToHrMinuteSec(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(seconds))!
        print(formattedString)
        return formattedString
    }
}
