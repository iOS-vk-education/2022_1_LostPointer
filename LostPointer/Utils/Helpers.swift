import Foundation

final class Helpers {
    static func convertSecondsToHrMinuteSec(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        let formattedString = formatter.string(from: TimeInterval(seconds))!
        print(formattedString)
        return formattedString
    }
}
