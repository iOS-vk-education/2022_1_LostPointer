import Foundation
import UIKit

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

final class Downloader {
    class func downloadImageWithURL(url: String) -> UIImage {
        guard let url = URL(string: url) else { return UIImage() }
        guard let data = NSData(contentsOf: url) else { return UIImage() }
        guard let img = UIImage(data: data as Data) else { return UIImage() }
        return img
    }
}
