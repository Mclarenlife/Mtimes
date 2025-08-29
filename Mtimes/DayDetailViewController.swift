import UIKit

protocol DayDetailDelegate: AnyObject {
    func dayDetailDidUpdate()
}

class DayDetailViewController: UIViewController {
    
    var date: Date!
    var records: [TimeRecord]!
    var timeRecordManager: TimeRecordManager!
    weak var delegate: DayDetailDelegate?
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalDurationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.systemBackground
        tableView.layer.cornerRadius = 16
        tableView.layer.shadowColor = UIColor.label.cgColor
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
        setupNavigationBar()
        updateDateInfo()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(dateLabel)
        view.addSubview(totalDurationLabel)
        view.addSubview(recordsTableView)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            totalDurationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            totalDurationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalDurationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            recordsTableView.topAnchor.constraint(equalTo: totalDurationLabel.bottomAnchor, constant: 20),
            recordsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recordsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recordsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        title = formatter.string(from: date)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecordTapped))
    }
    
    private func updateDateInfo() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        dateLabel.text = formatter.string(from: date)
        
        let totalDuration = records.reduce(0) { $0 + $1.duration }
        let hours = Int(totalDuration / 3600)
        let minutes = Int((totalDuration.truncatingRemainder(dividingBy: 3600)) / 60)
        totalDurationLabel.text = "今日总时长: \(hours)小时\(minutes)分钟"
    }
    
    @objc private func addRecordTapped() {
        let alert = UIAlertController(title: "添加打卡记录", message: "请选择操作", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "手动添加", style: .default) { _ in
            self.showAddRecordView()
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showAddRecordView() {
        let addVC = AddRecordViewController()
        addVC.date = date
        addVC.timeRecordManager = timeRecordManager
        addVC.delegate = self
        
        let navController = UINavigationController(rootViewController: addVC)
        present(navController, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension DayDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeRecordCell", for: indexPath) as! TimeRecordCell
        let record = records[indexPath.row]
        cell.configure(with: record, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let record = records[indexPath.row]
        let editVC = EditRecordViewController()
        editVC.record = record
        editVC.timeRecordManager = timeRecordManager
        editVC.delegate = self
        
        let navController = UINavigationController(rootViewController: editVC)
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let record = records[indexPath.row]
            timeRecordManager.deleteRecord(record)
            records.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateDateInfo()
            delegate?.dayDetailDidUpdate()
        }
    }
}

// MARK: - EditRecordDelegate
extension DayDetailViewController: EditRecordDelegate {
    func recordDidUpdate() {
        updateDateInfo()
        recordsTableView.reloadData()
        delegate?.dayDetailDidUpdate()
    }
}

// MARK: - AddRecordDelegate
extension DayDetailViewController: AddRecordDelegate {
    func recordDidAdd() {
        // 重新获取该日期的记录
        records = timeRecordManager.recordsForDate(date)
        updateDateInfo()
        recordsTableView.reloadData()
        delegate?.dayDetailDidUpdate()
    }
}

// MARK: - AddRecordViewController
class AddRecordViewController: UIViewController {
    
    var date: Date!
    var timeRecordManager: TimeRecordManager!
    weak var delegate: AddRecordDelegate?
    
    private lazy var startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "开始时间"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "结束时间"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let startTimeContainer = createTimeContainer(label: startTimeLabel, picker: startTimePicker)
        let endTimeContainer = createTimeContainer(label: endTimeLabel, picker: endTimePicker)
        
        stackView.addArrangedSubview(startTimeContainer)
        stackView.addArrangedSubview(endTimeContainer)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createTimeContainer(label: UILabel, picker: UIDatePicker) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        container.addSubview(picker)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            
            picker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            picker.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            picker.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            picker.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        
        return container
    }
    
    private func setupNavigationBar() {
        title = "添加打卡记录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        let startTime = startTimePicker.date
        let endTime = endTimePicker.date
        
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        
        guard let startDate = calendar.date(bySettingHour: startComponents.hour ?? 0, minute: startComponents.minute ?? 0, second: 0, of: date),
              let endDate = calendar.date(bySettingHour: endComponents.hour ?? 0, minute: endComponents.minute ?? 0, second: 0, of: date) else {
            showAlert(message: "时间设置无效")
            return
        }
        
        if startDate >= endDate {
            showAlert(message: "开始时间必须早于结束时间")
            return
        }
        
        let record = TimeRecord(startTime: startDate, endTime: endDate)
        timeRecordManager.records.append(record)
        timeRecordManager.saveRecords()
        
        delegate?.recordDidAdd()
        dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

protocol AddRecordDelegate: AnyObject {
    func recordDidAdd()
}
