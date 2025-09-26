import UIKit

class TimeRecordCell: UITableViewCell {
    
    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.backgroundColor = UIColor.label.withAlphaComponent(0.1)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recordNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.systemBackground
        selectionStyle = .none
        
        timeStackView.addArrangedSubview(startTimeLabel)
        timeStackView.addArrangedSubview(endTimeLabel)
        
        rightStackView.addArrangedSubview(dateLabel)
        rightStackView.addArrangedSubview(recordNumberLabel)
        
        contentView.addSubview(timeStackView)
        contentView.addSubview(durationLabel)
        contentView.addSubview(rightStackView)
        
        NSLayoutConstraint.activate([
            timeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeStackView.widthAnchor.constraint(equalToConstant: 80),
            
            durationLabel.leadingAnchor.constraint(equalTo: timeStackView.trailingAnchor, constant: 15),
            durationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            durationLabel.heightAnchor.constraint(equalToConstant: 32),
            durationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            
            rightStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rightStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightStackView.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func configure(with record: TimeRecord, index: Int, timeRecordManager: TimeRecordManager? = nil) {
        startTimeLabel.text = record.startTimeString
        endTimeLabel.text = record.endTimeString
        dateLabel.text = record.dateString
        
        // 设置用时标签
        let duration = record.duration
        if duration >= 3600 { // 大于等于1小时
            let hours = duration / 3600
            durationLabel.text = String(format: "%.1f小时", hours)
        } else {
            let minutes = Int(duration / 60)
            durationLabel.text = "\(minutes)分钟"
        }
        
        // 根据日期计算这是该天的第几次打卡
        let calendar = Calendar.current
        let today = Date()
        let recordDate = record.date
        
        if calendar.isDate(recordDate, inSameDayAs: today) {
            // 今天的打卡，显示"今天第x次"
            let todayRecords = getTodayRecordsCount(for: record, timeRecordManager: timeRecordManager)
            recordNumberLabel.text = "今天第\(todayRecords)次"
        } else if calendar.isDateInYesterday(recordDate) {
            // 昨天的打卡，显示"昨天第x次"
            let yesterdayRecords = getYesterdayRecordsCount(for: record, timeRecordManager: timeRecordManager)
            recordNumberLabel.text = "昨天第\(yesterdayRecords)次"
        } else {
            // 其他日期，显示具体日期
            let formatter = DateFormatter()
            formatter.dateFormat = "MM月dd日"
            let dateString = formatter.string(from: recordDate)
            let dayRecords = getDayRecordsCount(for: record, timeRecordManager: timeRecordManager)
            recordNumberLabel.text = "\(dateString)第\(dayRecords)次"
        }
    }
    
    private func getTodayRecordsCount(for record: TimeRecord, timeRecordManager: TimeRecordManager?) -> Int {
        guard let manager = timeRecordManager else { return 1 }
        let today = Date()
        let todayRecords = manager.recordsForDate(today)
        // 找到当前记录在今天的打卡中的位置
        let sortedRecords = todayRecords.sorted { $0.startTime < $1.startTime }
        if let index = sortedRecords.firstIndex(where: { $0.id == record.id }) {
            return index + 1
        }
        return 1
    }
    
    private func getYesterdayRecordsCount(for record: TimeRecord, timeRecordManager: TimeRecordManager?) -> Int {
        guard let manager = timeRecordManager else { return 1 }
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let yesterdayRecords = manager.recordsForDate(yesterday)
        // 找到当前记录在昨天的打卡中的位置
        let sortedRecords = yesterdayRecords.sorted { $0.startTime < $1.startTime }
        if let index = sortedRecords.firstIndex(where: { $0.id == record.id }) {
            return index + 1
        }
        return 1
    }
    
    private func getDayRecordsCount(for record: TimeRecord, timeRecordManager: TimeRecordManager?) -> Int {
        guard let manager = timeRecordManager else { return 1 }
        let dayRecords = manager.recordsForDate(record.date)
        // 找到当前记录在该天的打卡中的位置
        let sortedRecords = dayRecords.sorted { $0.startTime < $1.startTime }
        if let index = sortedRecords.firstIndex(where: { $0.id == record.id }) {
            return index + 1
        }
        return 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        startTimeLabel.text = ""
        endTimeLabel.text = ""
        durationLabel.text = ""
        dateLabel.text = ""
        recordNumberLabel.text = ""
    }
}
