import UIKit

class StatisticsViewController: UIViewController {
    
    var timeRecordManager: TimeRecordManager!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var effectiveDaysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var totalRecordsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.text = "总打卡次数"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalRecordsValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalDurationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.text = "总打卡时长"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalDurationValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.systemGreen
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var calendarView: CalendarView = {
        let calendar = CalendarView()
        calendar.timeRecordManager = timeRecordManager
        calendar.delegate = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    private lazy var recordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.systemBackground
        tableView.layer.cornerRadius = 16
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tableView.layer.shadowOpacity = 0.1
        tableView.layer.shadowRadius = 8
        tableView.register(TimeRecordCell.self, forCellReuseIdentifier: "TimeRecordCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
        recordsTableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(effectiveDaysLabel)
        contentView.addSubview(statsContainer)
        contentView.addSubview(calendarView)
        contentView.addSubview(recordsTableView)
        
        statsContainer.addSubview(totalRecordsLabel)
        statsContainer.addSubview(totalRecordsValueLabel)
        statsContainer.addSubview(totalDurationLabel)
        statsContainer.addSubview(totalDurationValueLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            effectiveDaysLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            effectiveDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            effectiveDaysLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            statsContainer.topAnchor.constraint(equalTo: effectiveDaysLabel.bottomAnchor, constant: 20),
            statsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsContainer.heightAnchor.constraint(equalToConstant: 100),
            
            totalRecordsLabel.topAnchor.constraint(equalTo: statsContainer.topAnchor, constant: 20),
            totalRecordsLabel.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor, constant: 20),
            totalRecordsLabel.widthAnchor.constraint(equalTo: statsContainer.widthAnchor, multiplier: 0.5),
            
            totalRecordsValueLabel.topAnchor.constraint(equalTo: totalRecordsLabel.bottomAnchor, constant: 8),
            totalRecordsValueLabel.leadingAnchor.constraint(equalTo: totalRecordsLabel.leadingAnchor),
            totalRecordsValueLabel.widthAnchor.constraint(equalTo: totalRecordsLabel.widthAnchor),
            
            totalDurationLabel.topAnchor.constraint(equalTo: statsContainer.topAnchor, constant: 20),
            totalDurationLabel.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor, constant: -20),
            totalDurationLabel.widthAnchor.constraint(equalTo: statsContainer.widthAnchor, multiplier: 0.5),
            
            totalDurationValueLabel.topAnchor.constraint(equalTo: totalDurationLabel.bottomAnchor, constant: 8),
            totalDurationValueLabel.trailingAnchor.constraint(equalTo: totalDurationLabel.trailingAnchor),
            totalDurationValueLabel.widthAnchor.constraint(equalTo: totalDurationLabel.widthAnchor),
            
            calendarView.topAnchor.constraint(equalTo: statsContainer.bottomAnchor, constant: 20),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            calendarView.heightAnchor.constraint(equalToConstant: 350),
            
            recordsTableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20),
            recordsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recordsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recordsTableView.heightAnchor.constraint(equalToConstant: 400),
            recordsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateStats() {
        // 计算有效打卡天数
        let effectiveDays = calculateEffectiveDays()
        effectiveDaysLabel.text = "有效逗留天数\(effectiveDays)天"
        
        totalRecordsValueLabel.text = "\(timeRecordManager.totalRecords)"
        
        let totalHours = timeRecordManager.totalDurationHours
        if totalHours >= 1 {
            totalDurationValueLabel.text = String(format: "%.1f小时", totalHours)
        } else {
            let minutes = Int(timeRecordManager.totalDuration / 60)
            totalDurationValueLabel.text = "\(minutes)分钟"
        }
    }
    
    private func calculateEffectiveDays() -> Int {
        let calendar = Calendar.current
        var effectiveDays = 0
        
        // 获取所有不重复的日期
        let uniqueDates = Set(timeRecordManager.records.map { record in
            calendar.startOfDay(for: record.date)
        })
        
        // 检查每个日期是否达到4小时的有效打卡时长
        for date in uniqueDates {
            let totalDurationForDay = timeRecordManager.totalDurationForDate(date)
            if totalDurationForDay >= 4 * 3600 { // 4小时 = 4 * 3600秒
                effectiveDays += 1
            }
        }
        
        return effectiveDays
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeRecordManager.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeRecordCell", for: indexPath) as! TimeRecordCell
        let sortedRecords = getSortedRecords()
        let record = sortedRecords[indexPath.row]
        cell.configure(with: record, index: indexPath.row, timeRecordManager: timeRecordManager)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 启用编辑功能
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 设置编辑样式为删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // 处理删除操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sortedRecords = getSortedRecords()
            let recordToDelete = sortedRecords[indexPath.row]
            
            // 显示确认删除的警告
            let alert = UIAlertController(title: "确认删除", message: "确定要删除这条打卡记录吗？此操作无法撤销。", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "删除", style: .destructive) { [weak self] _ in
                // 执行删除操作
                self?.timeRecordManager.deleteRecord(recordToDelete)
                
                // 更新UI
                self?.updateStats()
                self?.calendarView.reloadData()
                
                // 使用动画删除行
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    // 自定义删除按钮的标题
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sortedRecords = getSortedRecords()
        let record = sortedRecords[indexPath.row]
        let editVC = EditRecordViewController()
        editVC.record = record
        editVC.timeRecordManager = timeRecordManager
        editVC.delegate = self
        
        let navController = UINavigationController(rootViewController: editVC)
        present(navController, animated: true)
    }
    
    private func getSortedRecords() -> [TimeRecord] {
        // 按日期降序排列，最新的日期在最上方
        return timeRecordManager.records.sorted { record1, record2 in
            return record1.date > record2.date
        }
    }
}

// MARK: - CalendarViewDelegate
extension StatisticsViewController: CalendarViewDelegate {
    func calendarView(_ calendarView: CalendarView, didSelectDate date: Date) {
        // 添加调试信息
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        print("日历点击日期: \(formatter.string(from: date))")
        
        let records = timeRecordManager.recordsForDate(date)
        
        if !records.isEmpty {
            // 如果当天有打卡记录，显示详情页面
            let detailVC = DayDetailViewController()
            detailVC.date = date
            detailVC.records = records
            detailVC.timeRecordManager = timeRecordManager
            detailVC.delegate = self
            
            let navController = UINavigationController(rootViewController: detailVC)
            present(navController, animated: true)
        } else {
            // 如果当天没有打卡记录，创建新的打卡记录
            let startTime = Calendar.current.startOfDay(for: date)
            let endTime = startTime.addingTimeInterval(3600) // 默认1小时
            
            print("创建新记录 - 开始时间: \(formatter.string(from: startTime))")
            print("创建新记录 - 结束时间: \(formatter.string(from: endTime))")
            
            let newRecord = TimeRecord(startTime: startTime, endTime: endTime)
            let editVC = EditRecordViewController()
            editVC.record = newRecord
            editVC.timeRecordManager = timeRecordManager
            editVC.delegate = self
            
            let navController = UINavigationController(rootViewController: editVC)
            present(navController, animated: true)
        }
    }
}

// MARK: - EditRecordDelegate
extension StatisticsViewController: EditRecordDelegate {
    func recordDidUpdate() {
        updateStats()
        recordsTableView.reloadData()
        calendarView.reloadData()
    }
}

// MARK: - DayDetailDelegate
extension StatisticsViewController: DayDetailDelegate {
    func dayDetailDidUpdate() {
        updateStats()
        recordsTableView.reloadData()
        calendarView.reloadData()
    }
}
