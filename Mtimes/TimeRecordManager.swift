import Foundation
import UIKit

class TimeRecordManager: ObservableObject {
    @Published var records: [TimeRecord] = []
    @Published var isTracking: Bool = false
    @Published var isPaused: Bool = false
    @Published var currentStartTime: Date?
    @Published var currentElapsedTime: TimeInterval = 0
    @Published var pausedElapsedTime: TimeInterval = 0
    
    private var timer: Timer?
    private let userDefaults = UserDefaults.standard
    private let recordsKey = "TimeRecords"
    private let trackingKey = "IsTracking"
    private let pausedKey = "IsPaused"
    private let startTimeKey = "StartTime"
    private let pausedTimeKey = "PausedElapsedTime"
    
    init() {
        loadRecords()
        loadTrackingState()
        setupNotificationObserver()
    }
    
    // MARK: - 数据持久化
    func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            userDefaults.set(encoded, forKey: recordsKey)
        }
    }
    
    private func loadRecords() {
        if let data = userDefaults.data(forKey: recordsKey),
           let decoded = try? JSONDecoder().decode([TimeRecord].self, from: data) {
            records = decoded
        }
    }
    
    private func saveTrackingState() {
        userDefaults.set(isTracking, forKey: trackingKey)
        userDefaults.set(isPaused, forKey: pausedKey)
        if let startTime = currentStartTime {
            userDefaults.set(startTime, forKey: startTimeKey)
        } else {
            userDefaults.removeObject(forKey: startTimeKey)
        }
        userDefaults.set(pausedElapsedTime, forKey: pausedTimeKey)
    }
    
    private func loadTrackingState() {
        isTracking = userDefaults.bool(forKey: trackingKey)
        isPaused = userDefaults.bool(forKey: pausedKey)
        pausedElapsedTime = userDefaults.double(forKey: pausedTimeKey)
        
        if let startTime = userDefaults.object(forKey: startTimeKey) as? Date {
            currentStartTime = startTime
            if isTracking {
                startTimer()
                if isPaused {
                    currentElapsedTime = pausedElapsedTime
                }
            }
        }
    }
    
    // MARK: - 打卡功能
    func startTracking() {
        guard !isTracking else { return }
        
        isTracking = true
        isPaused = false
        currentStartTime = Date()
        currentElapsedTime = 0
        pausedElapsedTime = 0
        startTimer()
        saveTrackingState()
    }
    
    func pauseTracking() {
        guard isTracking, !isPaused else { return }
        
        isPaused = true
        pausedElapsedTime = currentElapsedTime
        stopTimer()
        saveTrackingState()
    }
    
    func resumeTracking() {
        guard isTracking, isPaused else { return }
        
        isPaused = false
        currentStartTime = Date().addingTimeInterval(-pausedElapsedTime)
        startTimer()
        saveTrackingState()
    }
    
    func stopTracking() {
        guard isTracking, let startTime = currentStartTime else { return }
        
        isTracking = false
        isPaused = false
        let endTime = Date()
        let record = TimeRecord(startTime: startTime, endTime: endTime)
        
        records.append(record)
        saveRecords()
        
        currentStartTime = nil
        currentElapsedTime = 0
        pausedElapsedTime = 0
        stopTimer()
        saveTrackingState()
    }
    
    func resetTracking() {
        isTracking = false
        isPaused = false
        currentStartTime = nil
        currentElapsedTime = 0
        pausedElapsedTime = 0
        stopTimer()
        saveTrackingState()
    }
    
    // MARK: - 计时器
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.currentStartTime else { return }
            self.currentElapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - 统计功能
    var totalRecords: Int {
        return records.count
    }
    
    var totalDuration: TimeInterval {
        return records.reduce(0) { $0 + $1.duration }
    }
    
    var totalDurationHours: Double {
        return totalDuration / 3600.0
    }
    
    func recordsForDate(_ date: Date) -> [TimeRecord] {
        let calendar = Calendar.current
        return records.filter { record in
            calendar.isDate(record.date, inSameDayAs: date)
        }
    }
    
    func hasRecordForDate(_ date: Date) -> Bool {
        return !recordsForDate(date).isEmpty
    }
    
    func totalDurationForDate(_ date: Date) -> TimeInterval {
        return recordsForDate(date).reduce(0) { $0 + $1.duration }
    }
    
    // MARK: - 编辑功能
    func updateRecord(_ record: TimeRecord, newStartTime: Date, newEndTime: Date) {
        print("updateRecord called - record ID: \(record.id)")
        print("Current records count: \(records.count)")
        
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            print("Updating existing record at index: \(index)")
            // 更新现有记录
            records[index].startTime = newStartTime
            records[index].endTime = newEndTime
            records[index].date = newStartTime
            saveRecords()
            print("Record updated successfully")
        } else {
            print("Record not found, creating new record")
            // 如果记录不存在，创建新记录并添加到数组中
            let newRecord = TimeRecord(startTime: newStartTime, endTime: newEndTime)
            records.append(newRecord)
            saveRecords()
            print("New record added successfully, total records: \(records.count)")
        }
    }
    
    func deleteRecord(_ record: TimeRecord) {
        records.removeAll { $0.id == record.id }
        saveRecords()
    }
    
    @objc private func appDidEnterBackground() {
        stopTimer()
        saveTrackingState()
    }
    
    @objc private func appWillEnterForeground() {
        if isTracking {
            currentStartTime = Date().addingTimeInterval(-pausedElapsedTime)
            startTimer()
            saveTrackingState()
        }
    }
    
    // MARK: - 通知监听
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleImportDataRequest),
            name: NSNotification.Name("ImportDataRequested"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataCleared),
            name: NSNotification.Name("DataCleared"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleImportDataRequest() {
        // 重新加载数据，因为导入的数据已经保存到UserDefaults
        loadRecords()
    }
    
    @objc private func handleDataCleared() {
        // 清空所有数据
        records.removeAll()
        isTracking = false
        isPaused = false
        currentStartTime = nil
        currentElapsedTime = 0
        pausedElapsedTime = 0
        stopTimer()
        
        // 保存清空后的状态
        saveRecords()
        saveTrackingState()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 导入数据功能
    func importRecords(_ newRecords: [TimeRecord]) {
        // 清空现有数据
        records.removeAll()
        
        // 添加新数据
        records = newRecords
        
        // 保存到UserDefaults
        saveRecords()
        
        // 发送通知，通知UI更新
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // MARK: - 导出数据功能
    func exportRecords() -> Data? {
        return try? JSONEncoder().encode(records)
    }
}
