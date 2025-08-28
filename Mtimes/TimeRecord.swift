import Foundation

class TimeRecord: Codable, Identifiable {
    let id = UUID()
    var startTime: Date
    var endTime: Date
    var date: Date
    
    var duration: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
    
    var durationHours: Double {
        return duration / 3600.0
    }
    
    var durationMinutes: Int {
        return Int(duration / 60.0)
    }
    
    var startTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: startTime)
    }
    
    var endTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: endTime)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter.string(from: date)
    }
    
    init(startTime: Date, endTime: Date) {
        self.startTime = startTime
        self.endTime = endTime
        self.date = startTime
    }
}
