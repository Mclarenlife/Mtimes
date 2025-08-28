import UIKit

protocol EditRecordDelegate: AnyObject {
    func recordDidUpdate()
}

class EditRecordViewController: UIViewController {
    
    var record: TimeRecord!
    var timeRecordManager: TimeRecordManager!
    weak var delegate: EditRecordDelegate?
    
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
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
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
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "日期"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupPickers()
        updateDurationLabel()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 创建滚动视图
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        // 创建内容视图
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 开始时间
        let startTimeContainer = createTimeContainer(label: startTimeLabel, picker: startTimePicker)
        
        // 结束时间
        let endTimeContainer = createTimeContainer(label: endTimeLabel, picker: endTimePicker)
        
        // 日期
        let dateContainer = createDateContainer()
        
        // 时长显示
        let durationContainer = UIView()
        durationContainer.backgroundColor = UIColor.systemGray6
        durationContainer.layer.cornerRadius = 12
        durationContainer.translatesAutoresizingMaskIntoConstraints = false
        
        durationContainer.addSubview(durationLabel)
        NSLayoutConstraint.activate([
            durationLabel.centerXAnchor.constraint(equalTo: durationContainer.centerXAnchor),
            durationLabel.centerYAnchor.constraint(equalTo: durationContainer.centerYAnchor)
        ])
        
        stackView.addArrangedSubview(startTimeContainer)
        stackView.addArrangedSubview(endTimeContainer)
        stackView.addArrangedSubview(dateContainer)
        stackView.addArrangedSubview(durationContainer)
        
        // 设置视图层次
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 滚动视图约束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 内容视图约束
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 堆栈视图约束
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            durationContainer.heightAnchor.constraint(equalToConstant: 60)
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
    
    private func createDateContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(dateLabel)
        container.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            
            datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        
        return container
    }
    
    private func setupNavigationBar() {
        title = "编辑打卡记录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    private func setupPickers() {
        startTimePicker.date = record.startTime
        endTimePicker.date = record.endTime
        datePicker.date = record.date
        
        startTimePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        endTimePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc private func timeChanged() {
        updateDurationLabel()
    }
    
    @objc private func dateChanged() {
        updateDurationLabel()
    }
    
    private func updateDurationLabel() {
        let startTime = startTimePicker.date
        let endTime = endTimePicker.date
        let date = datePicker.date
        
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        guard let startDate = calendar.date(bySettingHour: startComponents.hour ?? 0, minute: startComponents.minute ?? 0, second: 0, of: date),
              let endDate = calendar.date(bySettingHour: endComponents.hour ?? 0, minute: endComponents.minute ?? 0, second: 0, of: date) else {
            return
        }
        
        let duration = endDate.timeIntervalSince(startDate)
        if duration > 0 {
            let hours = Int(duration / 3600)
            let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
            durationLabel.text = "时长: \(hours)小时\(minutes)分钟"
        } else {
            durationLabel.text = "时长: 无效时间"
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        let startTime = startTimePicker.date
        let endTime = endTimePicker.date
        let date = datePicker.date
        
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        guard let startDate = calendar.date(bySettingHour: startComponents.hour ?? 0, minute: startComponents.minute ?? 0, second: 0, of: date),
              let endDate = calendar.date(bySettingHour: endComponents.hour ?? 0, minute: endComponents.minute ?? 0, second: 0, of: date) else {
            showAlert(message: "时间设置无效")
            return
        }
        
        if startDate >= endDate {
            showAlert(message: "开始时间必须早于结束时间")
            return
        }
        
        timeRecordManager.updateRecord(record, newStartTime: startDate, newEndTime: endDate)
        delegate?.recordDidUpdate()
        dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
