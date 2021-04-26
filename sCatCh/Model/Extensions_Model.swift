
import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
    
    func toInt() -> Int {
        Int(self) ?? 0
    }
}

extension Optional {
    func toInt() -> Int {
        self as? Int ?? 0
    }
    
    func toString() -> String {
        self as? String ?? ""
    }
}
