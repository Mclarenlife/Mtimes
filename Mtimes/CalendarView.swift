import UIKit

protocol CalendarViewDelegate: AnyObject {
    func calendarView(_ calendarView: CalendarView, didSelectDate date: Date)
    func calendarView(_ calendarView: CalendarView, didChangeMonth date: Date)
}

class CalendarView: UIView {
    
    weak var delegate: CalendarViewDelegate?
    var timeRecordManager: TimeRecordManager!
    
    // 添加公共属性来访问当前显示的日期
    var currentDate: Date {
        return _currentDate
    }
    
    private var _currentDate = Date()
    private var selectedDate: Date?
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var previousMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("‹", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(previousMonthTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("›", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(nextMonthTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var weekdaysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "CalendarDayCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupWeekdays()
        updateMonthLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupWeekdays()
        updateMonthLabel()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.systemBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 8
        
        addSubview(monthLabel)
        addSubview(previousMonthButton)
        addSubview(nextMonthButton)
        addSubview(weekdaysStackView)
        addSubview(calendarCollectionView)
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            previousMonthButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            previousMonthButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            previousMonthButton.widthAnchor.constraint(equalToConstant: 44),
            previousMonthButton.heightAnchor.constraint(equalToConstant: 44),
            
            nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextMonthButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            nextMonthButton.widthAnchor.constraint(equalToConstant: 44),
            nextMonthButton.heightAnchor.constraint(equalToConstant: 44),
            
            weekdaysStackView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20),
            weekdaysStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            weekdaysStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            weekdaysStackView.heightAnchor.constraint(equalToConstant: 30),
            
            calendarCollectionView.topAnchor.constraint(equalTo: weekdaysStackView.bottomAnchor, constant: 15),
            calendarCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            calendarCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            calendarCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    private func setupWeekdays() {
        let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
        
        for weekday in weekdays {
            let label = UILabel()
            label.text = weekday
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textColor = UIColor.secondaryLabel
            label.textAlignment = .center
            weekdaysStackView.addArrangedSubview(label)
        }
    }
    
    private func updateMonthLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        monthLabel.text = formatter.string(from: currentDate)
    }
    
    @objc private func previousMonthTapped() {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            _currentDate = newDate
            updateMonthLabel()
            calendarCollectionView.reloadData()
            delegate?.calendarView(self, didChangeMonth: newDate)
        }
    }
    
    @objc private func nextMonthTapped() {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            _currentDate = newDate
            updateMonthLabel()
            calendarCollectionView.reloadData()
            delegate?.calendarView(self, didChangeMonth: newDate)
        }
    }
    
    func reloadData() {
        calendarCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let firstWeekday = calendar.component(.weekday, from: currentDate)
        let offsetDays = firstWeekday - 1
        
        return range.count + offsetDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        
        let calendar = Calendar.current
        let firstWeekday = calendar.component(.weekday, from: currentDate)
        let offsetDays = firstWeekday - 1
        
        if indexPath.item < offsetDays {
            cell.configureEmpty()
        } else {
            let day = indexPath.item - offsetDays + 1
            
            // 修复日期计算问题：确保日期在正确的月份
            var components = calendar.dateComponents([.year, .month], from: currentDate)
            components.day = day
            
            // 验证日期是否有效（避免无效日期如2月30日）
            if let date = calendar.date(from: components) {
                let hasRecord = timeRecordManager.hasRecordForDate(date)
                let duration = timeRecordManager.totalDurationForDate(date)
                
                cell.configure(day: day, hasRecord: hasRecord, duration: duration)
            } else {
                // 如果日期无效，配置为空
                cell.configureEmpty()
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CalendarView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let calendar = Calendar.current
        let firstWeekday = calendar.component(.weekday, from: currentDate)
        let offsetDays = firstWeekday - 1
        
        if indexPath.item >= offsetDays {
            let day = indexPath.item - offsetDays + 1
            
            // 修复日期计算问题：确保日期在正确的月份
            var components = calendar.dateComponents([.year, .month], from: currentDate)
            components.day = day
            
            // 验证日期是否有效（避免无效日期如2月30日）
            if let date = calendar.date(from: components) {
                // 添加调试信息
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy年MM月dd日"
                print("CalendarView - 当前月份: \(formatter.string(from: currentDate))")
                print("CalendarView - 点击日期: \(formatter.string(from: date))")
                print("CalendarView - 点击的day值: \(day)")
                
                delegate?.calendarView(self, didSelectDate: date)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 12) / 7
        return CGSize(width: width, height: width)
    }
}

// MARK: - CalendarDayCell
class CalendarDayCell: UICollectionViewCell {
    
    private let dayLabel = UILabel()
    private let progressView = CircularProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        dayLabel.textColor = UIColor.label
        dayLabel.textAlignment = .center
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 32),
            progressView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configureEmpty() {
        dayLabel.text = ""
        progressView.isHidden = true
    }
    
    func configure(day: Int, hasRecord: Bool, duration: TimeInterval) {
        dayLabel.text = "\(day)"
        progressView.isHidden = !hasRecord
        
        if hasRecord {
            let progress = Float(min(duration / (4 * 3600), 1.0)) // 4小时为一圈
            progressView.setProgress(progress, animated: false)
        }
    }
}

// MARK: - CircularProgressView
class CircularProgressView: UIView {
    
    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.systemGray5.cgColor
        backgroundLayer.lineWidth = 3
        backgroundLayer.lineCap = .round
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.label.cgColor
        progressLayer.lineWidth = 3
        progressLayer.lineCap = .round
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 2
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        backgroundLayer.path = circlePath.cgPath
        progressLayer.path = circlePath.cgPath
    }
    
    func setProgress(_ progress: Float, animated: Bool) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = progress
        animation.duration = animated ? 0.3 : 0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        progressLayer.strokeEnd = CGFloat(progress)
        progressLayer.add(animation, forKey: "strokeEnd")
    }
}
