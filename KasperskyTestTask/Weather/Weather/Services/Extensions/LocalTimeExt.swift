import Foundation

extension String {

    func getCurrentTime() -> String {
        let dateAndTime = self.split(separator: " ")

        if dateAndTime.count == 2 {
            return String(dateAndTime[1])
        }

        return ""
    }

}
