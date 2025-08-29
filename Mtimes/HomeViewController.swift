import UIKit

class HomeViewController: UIViewController {
    
    var timeRecordManager: TimeRecordManager!
    
    // MARK: - UI Components
    private let statusLabel = UILabel()
    private let timerContainer = UIView()
    private let timerLabel = UILabel()
    private let progressView = TimerProgressView()
    private let pauseResumeButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    
    private var displayLink: CADisplayLink?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStatusLabel()
        updateTimerDisplay()
        updateButtonStates()
        startDisplayLink()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatusLabel()
        updateTimerDisplay()
        updateButtonStates()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 状态标签
        statusLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        statusLabel.textColor = UIColor.label
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.text = "今日还未打卡"
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 计时器容器
        timerContainer.backgroundColor = UIColor.clear
        timerContainer.layer.cornerRadius = 100
        timerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // 计时器标签
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .medium)
        timerLabel.textColor = UIColor.label
        timerLabel.textAlignment = .center
        timerLabel.text = "开始"
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 进度视图
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        // 按钮堆栈视图
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 16
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 暂停/继续按钮
        pauseResumeButton.setTitle("开始", for: .normal)
        pauseResumeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        pauseResumeButton.backgroundColor = UIColor.systemBackground
        pauseResumeButton.setTitleColor(UIColor.label, for: .normal)
        pauseResumeButton.layer.cornerRadius = 20
        pauseResumeButton.layer.borderWidth = 1
        pauseResumeButton.layer.borderColor = UIColor.label.cgColor
        pauseResumeButton.addTarget(self, action: #selector(pauseResumeButtonTapped), for: .touchUpInside)
        
        // 重置按钮
        resetButton.setTitle("重置", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        resetButton.backgroundColor = UIColor.systemBackground
        resetButton.setTitleColor(UIColor.label, for: .normal)
        resetButton.layer.cornerRadius = 20
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.label.cgColor
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        // 保存按钮
        saveButton.setTitle("保存", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        saveButton.backgroundColor = UIColor.label
        saveButton.setTitleColor(UIColor.systemBackground, for: .normal)
        saveButton.layer.cornerRadius = 20
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        // 添加到视图
        view.addSubview(statusLabel)
        view.addSubview(timerContainer)
        timerContainer.addSubview(timerLabel)
        timerContainer.addSubview(progressView)
        view.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(pauseResumeButton)
        buttonStackView.addArrangedSubview(resetButton)
        buttonStackView.addArrangedSubview(saveButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 状态标签
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 计时器容器
            timerContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            timerContainer.widthAnchor.constraint(equalToConstant: 280),
            timerContainer.heightAnchor.constraint(equalToConstant: 280),
            
            // 计时器标签
            timerLabel.centerXAnchor.constraint(equalTo: timerContainer.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerContainer.centerYAnchor),
            
            // 进度视图
            progressView.centerXAnchor.constraint(equalTo: timerContainer.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: timerContainer.centerYAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 260),
            progressView.heightAnchor.constraint(equalToConstant: 260),
            
            // 按钮堆栈视图
            buttonStackView.topAnchor.constraint(equalTo: timerContainer.bottomAnchor, constant: 40),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: 200),
            buttonStackView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    // MARK: - Actions
    @objc private func pauseResumeButtonTapped() {
        if !timeRecordManager.isTracking {
            // 开始计时
            timeRecordManager.startTracking()
        } else if timeRecordManager.isPaused {
            // 继续计时
            timeRecordManager.resumeTracking()
        } else {
            // 暂停计时
            timeRecordManager.pauseTracking()
        }
        
        updateStatusLabel()
        updateTimerDisplay()
        updateButtonStates()
    }
    
    @objc private func resetButtonTapped() {
        let alert = UIAlertController(title: "确认重置", message: "确定要重置当前计时吗？这将清除所有计时数据。", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "重置", style: .destructive) { _ in
            self.timeRecordManager.resetTracking()
            self.updateStatusLabel()
            self.updateTimerDisplay()
            self.updateButtonStates()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard timeRecordManager.isTracking else { return }
        
        timeRecordManager.stopTracking()
        updateStatusLabel()
        updateTimerDisplay()
        updateButtonStates()
        
        // 显示保存成功提示
        let alert = UIAlertController(title: "保存成功", message: "打卡记录已保存", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Updates
    private func updateStatusLabel() {
        let today = Date()
        
        if timeRecordManager.hasRecordForDate(today) {
            let duration = timeRecordManager.totalDurationForDate(today)
            let hours = Int(duration / 3600)
            let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
            
            // 创建富文本字符串
            let attributedString = NSMutableAttributedString()
            
            // 第一行："今日逗留"
            let firstLineAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                .foregroundColor: UIColor.label
            ]
            let firstLineString = NSAttributedString(string: "今日逗留", attributes: firstLineAttributes)
            attributedString.append(firstLineString)
            
            // 添加换行符
            let newlineAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .medium),
                .foregroundColor: UIColor.label
            ]
            let newlineString = NSAttributedString(string: "\n", attributes: newlineAttributes)
            attributedString.append(newlineString)
            
            // 第二行："x小时x分钟" - 加粗且字号更大
            let secondLineAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                .foregroundColor: UIColor.label
            ]
            let secondLineString = NSAttributedString(string: "\(hours)小时\(minutes)分钟", attributes: secondLineAttributes)
            attributedString.append(secondLineString)
            
            // 设置段落样式以增加行间距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 12
            paragraphStyle.alignment = .center
            
            // 将段落样式应用到整个字符串
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            
            statusLabel.attributedText = attributedString
        } else {
            statusLabel.text = "今日还未打卡"
        }
    }
    
    private func updateTimerDisplay() {
        if timeRecordManager.isTracking {
            // 使用新的基于时间差的计算方法
            let elapsedTime = timeRecordManager.getCurrentElapsedTime()
            let hours = Int(elapsedTime / 3600)
            let minutes = Int((elapsedTime.truncatingRemainder(dividingBy: 3600)) / 60)
            let seconds = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
            timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            
            let progress = Float(min(elapsedTime / (4 * 3600), 1.0)) // 4小时为一圈
            progressView.setProgress(progress, animated: true)
        } else {
            timerLabel.text = "开始"
            progressView.setProgress(0, animated: true)
        }
    }
    
    private func updateButtonStates() {
        if !timeRecordManager.isTracking {
            // 未开始计时
            pauseResumeButton.setTitle("开始", for: .normal)
            pauseResumeButton.backgroundColor = UIColor.systemBackground
            resetButton.isEnabled = false
            resetButton.alpha = 0.5
            saveButton.isEnabled = false
            saveButton.alpha = 0.5
        } else if timeRecordManager.isPaused {
            // 计时已暂停
            pauseResumeButton.setTitle("继续", for: .normal)
            pauseResumeButton.backgroundColor = UIColor.systemBackground
            resetButton.isEnabled = true
            resetButton.alpha = 1.0
            saveButton.isEnabled = true
            saveButton.alpha = 1.0
        } else {
            // 计时进行中
            pauseResumeButton.setTitle("暂停", for: .normal)
            pauseResumeButton.backgroundColor = UIColor.systemBackground
            resetButton.isEnabled = true
            resetButton.alpha = 1.0
            saveButton.isEnabled = true
            saveButton.alpha = 1.0
        }
    }
    
    // MARK: - Display Link
    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateTimer))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateTimer() {
        if timeRecordManager.isTracking {
            updateTimerDisplay()
        }
    }
    
    // MARK: - Cleanup
    deinit {
        displayLink?.invalidate()
    }
}

// MARK: - Timer Progress View
class TimerProgressView: UIView {
    
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
        
        // 背景圆环
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.systemGray4.cgColor
        backgroundLayer.lineWidth = 8
        backgroundLayer.lineCap = .round
        
        // 进度圆环
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.label.cgColor
        progressLayer.lineWidth = 8
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 4
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        
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
