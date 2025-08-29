import UIKit
import UniformTypeIdentifiers

class SettingsViewController: UIViewController {
    
    // MARK: - 滚动视图
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "设置"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var themeSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var themeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "主题设置"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var themeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "选择您喜欢的应用外观"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lightModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("☀️ 浅色模式", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.tertiarySystemBackground
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
        button.setTitleColor(UIColor.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(lightModeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var darkModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🌙 深色模式", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.tertiarySystemBackground
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
        button.setTitleColor(UIColor.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(darkModeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var systemModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⚙️ 跟随系统", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.tertiarySystemBackground
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
        button.setTitleColor(UIColor.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(systemModeTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 数据管理部分
    private lazy var dataSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var dataTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "数据管理"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dataDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "导入、导出或清空您的打卡数据"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📤 导出数据", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.tertiarySystemBackground
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
        button.setTitleColor(UIColor.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exportDataTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var importButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📥 导入数据", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.tertiarySystemBackground
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
        button.setTitleColor(UIColor.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(importDataTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var clearDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🗑️ 清空全部数据", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearDataTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 关于软件部分
    private lazy var aboutSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var aboutTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "关于软件"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aboutDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "应用信息和联系方式"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var versionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📱 版本号: 1.0.0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.tertiarySystemBackground
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
        button.setTitleColor(UIColor.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(versionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var feedbackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("反馈建议: xiangjinleee@gmail.com", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.tertiarySystemBackground
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
        button.setTitleColor(UIColor.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(feedbackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 底部留白区域
    private lazy var bottomSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var currentThemeMode: UIUserInterfaceStyle = .unspecified
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCurrentThemeMode()
        updateButtonStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCurrentThemeMode()
        updateButtonStates()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加所有子视图到内容视图
        contentView.addSubview(titleLabel)
        contentView.addSubview(themeSectionView)
        contentView.addSubview(dataSectionView)
        contentView.addSubview(aboutSectionView)
        contentView.addSubview(bottomSpacerView)
        
        themeSectionView.addSubview(themeTitleLabel)
        themeSectionView.addSubview(themeDescriptionLabel)
        themeSectionView.addSubview(lightModeButton)
        themeSectionView.addSubview(darkModeButton)
        themeSectionView.addSubview(systemModeButton)
        
        dataSectionView.addSubview(dataTitleLabel)
        dataSectionView.addSubview(dataDescriptionLabel)
        dataSectionView.addSubview(exportButton)
        dataSectionView.addSubview(importButton)
        dataSectionView.addSubview(clearDataButton)
        
        aboutSectionView.addSubview(aboutTitleLabel)
        aboutSectionView.addSubview(aboutDescriptionLabel)
        aboutSectionView.addSubview(versionButton)
        aboutSectionView.addSubview(feedbackButton)
        
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
            
            // 标题约束
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 主题设置部分约束
            themeSectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            themeSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            themeSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            themeTitleLabel.topAnchor.constraint(equalTo: themeSectionView.topAnchor, constant: 25),
            themeTitleLabel.leadingAnchor.constraint(equalTo: themeSectionView.leadingAnchor, constant: 25),
            themeTitleLabel.trailingAnchor.constraint(equalTo: themeSectionView.trailingAnchor, constant: -25),
            
            themeDescriptionLabel.topAnchor.constraint(equalTo: themeTitleLabel.bottomAnchor, constant: 12),
            themeDescriptionLabel.leadingAnchor.constraint(equalTo: themeSectionView.leadingAnchor, constant: 25),
            themeDescriptionLabel.trailingAnchor.constraint(equalTo: themeSectionView.trailingAnchor, constant: -25),
            
            lightModeButton.topAnchor.constraint(equalTo: themeDescriptionLabel.bottomAnchor, constant: 25),
            lightModeButton.leadingAnchor.constraint(equalTo: themeSectionView.leadingAnchor, constant: 25),
            lightModeButton.trailingAnchor.constraint(equalTo: themeSectionView.trailingAnchor, constant: -25),
            lightModeButton.heightAnchor.constraint(equalToConstant: 70),
            
            darkModeButton.topAnchor.constraint(equalTo: lightModeButton.bottomAnchor, constant: 16),
            darkModeButton.leadingAnchor.constraint(equalTo: themeSectionView.leadingAnchor, constant: 25),
            darkModeButton.trailingAnchor.constraint(equalTo: themeSectionView.trailingAnchor, constant: -25),
            darkModeButton.heightAnchor.constraint(equalToConstant: 70),
            
            systemModeButton.topAnchor.constraint(equalTo: darkModeButton.bottomAnchor, constant: 16),
            systemModeButton.leadingAnchor.constraint(equalTo: themeSectionView.leadingAnchor, constant: 25),
            systemModeButton.trailingAnchor.constraint(equalTo: themeSectionView.trailingAnchor, constant: -25),
            systemModeButton.heightAnchor.constraint(equalToConstant: 70),
            systemModeButton.bottomAnchor.constraint(equalTo: themeSectionView.bottomAnchor, constant: -25),
            
            // 数据管理部分约束
            dataSectionView.topAnchor.constraint(equalTo: themeSectionView.bottomAnchor, constant: 30),
            dataSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dataSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dataTitleLabel.topAnchor.constraint(equalTo: dataSectionView.topAnchor, constant: 25),
            dataTitleLabel.leadingAnchor.constraint(equalTo: dataSectionView.leadingAnchor, constant: 25),
            dataTitleLabel.trailingAnchor.constraint(equalTo: dataSectionView.trailingAnchor, constant: -25),
            
            dataDescriptionLabel.topAnchor.constraint(equalTo: dataTitleLabel.bottomAnchor, constant: 12),
            dataDescriptionLabel.leadingAnchor.constraint(equalTo: dataSectionView.leadingAnchor, constant: 25),
            dataDescriptionLabel.trailingAnchor.constraint(equalTo: dataSectionView.trailingAnchor, constant: -25),
            
            exportButton.topAnchor.constraint(equalTo: dataDescriptionLabel.bottomAnchor, constant: 25),
            exportButton.leadingAnchor.constraint(equalTo: dataSectionView.leadingAnchor, constant: 25),
            exportButton.trailingAnchor.constraint(equalTo: dataSectionView.trailingAnchor, constant: -25),
            exportButton.heightAnchor.constraint(equalToConstant: 70),
            
            importButton.topAnchor.constraint(equalTo: exportButton.bottomAnchor, constant: 16),
            importButton.leadingAnchor.constraint(equalTo: dataSectionView.leadingAnchor, constant: 25),
            importButton.trailingAnchor.constraint(equalTo: dataSectionView.trailingAnchor, constant: -25),
            importButton.heightAnchor.constraint(equalToConstant: 70),
            
            clearDataButton.topAnchor.constraint(equalTo: importButton.bottomAnchor, constant: 16),
            clearDataButton.leadingAnchor.constraint(equalTo: dataSectionView.leadingAnchor, constant: 25),
            clearDataButton.trailingAnchor.constraint(equalTo: dataSectionView.trailingAnchor, constant: -25),
            clearDataButton.heightAnchor.constraint(equalToConstant: 70),
            clearDataButton.bottomAnchor.constraint(equalTo: dataSectionView.bottomAnchor, constant: -25),
            
            // 关于软件部分约束
            aboutSectionView.topAnchor.constraint(equalTo: dataSectionView.bottomAnchor, constant: 30),
            aboutSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            aboutTitleLabel.topAnchor.constraint(equalTo: aboutSectionView.topAnchor, constant: 25),
            aboutTitleLabel.leadingAnchor.constraint(equalTo: aboutSectionView.leadingAnchor, constant: 25),
            aboutTitleLabel.trailingAnchor.constraint(equalTo: aboutSectionView.trailingAnchor, constant: -25),
            
            aboutDescriptionLabel.topAnchor.constraint(equalTo: aboutTitleLabel.bottomAnchor, constant: 12),
            aboutDescriptionLabel.leadingAnchor.constraint(equalTo: aboutSectionView.leadingAnchor, constant: 25),
            aboutDescriptionLabel.trailingAnchor.constraint(equalTo: aboutSectionView.trailingAnchor, constant: -25),
            
            versionButton.topAnchor.constraint(equalTo: aboutDescriptionLabel.bottomAnchor, constant: 25),
            versionButton.leadingAnchor.constraint(equalTo: aboutSectionView.leadingAnchor, constant: 25),
            versionButton.trailingAnchor.constraint(equalTo: aboutSectionView.trailingAnchor, constant: -25),
            versionButton.heightAnchor.constraint(equalToConstant: 70),
            
            feedbackButton.topAnchor.constraint(equalTo: versionButton.bottomAnchor, constant: 16),
            feedbackButton.leadingAnchor.constraint(equalTo: aboutSectionView.leadingAnchor, constant: 25),
            feedbackButton.trailingAnchor.constraint(equalTo: aboutSectionView.trailingAnchor, constant: -25),
            feedbackButton.heightAnchor.constraint(equalToConstant: 70),
            feedbackButton.bottomAnchor.constraint(equalTo: aboutSectionView.bottomAnchor, constant: -25),
            
            // 底部留白区域约束
            bottomSpacerView.topAnchor.constraint(equalTo: aboutSectionView.bottomAnchor, constant: 30),
            bottomSpacerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomSpacerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomSpacerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomSpacerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
    // MARK: - 主题设置方法
    @objc private func lightModeTapped() {
        setThemeMode(.light)
    }
    
    @objc private func darkModeTapped() {
        setThemeMode(.dark)
    }
    
    @objc private func systemModeTapped() {
        setThemeMode(.unspecified)
    }
    
    private func setThemeMode(_ mode: UIUserInterfaceStyle) {
        currentThemeMode = mode
        
        // 保存用户选择到 UserDefaults
        UserDefaults.standard.set(mode.rawValue, forKey: "UserInterfaceStyle")
        
        // 应用主题到当前窗口
        if let window = view.window {
            window.overrideUserInterfaceStyle = mode
        }
        
        // 应用主题到所有窗口
        if let windowScene = view.window?.windowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = mode
            }
        }
        
        updateButtonStates()
    }
    
    private func updateCurrentThemeMode() {
        let savedMode = UserDefaults.standard.integer(forKey: "UserInterfaceStyle")
        currentThemeMode = UIUserInterfaceStyle(rawValue: savedMode) ?? .unspecified
    }
    
    private func updateButtonStates() {
        // 重置所有按钮状态
        [lightModeButton, darkModeButton, systemModeButton].forEach { button in
            button.backgroundColor = UIColor.tertiarySystemBackground
            button.layer.borderColor = UIColor.separator.cgColor
            button.setTitleColor(UIColor.label, for: .normal)
        }
        
        // 设置当前选中按钮的状态
        let selectedButton: UIButton
        switch currentThemeMode {
        case .light:
            selectedButton = lightModeButton
        case .dark:
            selectedButton = darkModeButton
        case .unspecified:
            selectedButton = systemModeButton
        @unknown default:
            selectedButton = systemModeButton
        }
        
        selectedButton.backgroundColor = UIColor.label.withAlphaComponent(0.1)
        selectedButton.layer.borderColor = UIColor.label.cgColor
        selectedButton.setTitleColor(UIColor.label, for: .normal)
    }
    
    // MARK: - 数据管理方法
    @objc private func exportDataTapped() {
        exportData()
    }
    
    @objc private func importDataTapped() {
        importData()
    }
    
    @objc private func clearDataTapped() {
        showClearDataConfirmation()
    }
    
    private func exportData() {
        // 获取所有时间记录
        guard let data = UserDefaults.standard.data(forKey: "TimeRecords"),
              let records = try? JSONDecoder().decode([TimeRecord].self, from: data) else {
            showAlert(title: "导出失败", message: "没有可导出的数据")
            return
        }
        
        // 创建导出数据结构
        let exportData = ExportData(
            version: "1.0.0",
            exportDate: Date(),
            records: records
        )
        
        // 编码为JSON
        guard let jsonData = try? JSONEncoder().encode(exportData) else {
            showAlert(title: "导出失败", message: "数据编码失败")
            return
        }
        
        // 创建临时文件
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Mtimes_Export_\(Date().timeIntervalSince1970).json")
        
        do {
            try jsonData.write(to: tempURL)
            
            // 显示分享界面
            let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            present(activityViewController, animated: true)
            
        } catch {
            showAlert(title: "导出失败", message: "文件创建失败: \(error.localizedDescription)")
        }
    }
    
    private func importData() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.json])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        present(documentPicker, animated: true)
    }
    
    private func showClearDataConfirmation() {
        let alert = UIAlertController(
            title: "确认清空数据",
            message: "此操作将删除所有打卡记录，且无法恢复。确定要继续吗？",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定清空", style: .destructive) { [weak self] _ in
            self?.clearAllData()
        })
        
        present(alert, animated: true)
    }
    
    private func clearAllData() {
        // 清空UserDefaults中的数据
        UserDefaults.standard.removeObject(forKey: "TimeRecords")
        
        // 发送通知，通知其他视图更新
        NotificationCenter.default.post(name: NSNotification.Name("DataCleared"), object: nil)
        
        showAlert(title: "数据已清空", message: "所有打卡记录已被删除")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showImportConfirmationAlert(recordCount: Int) {
        let alert = UIAlertController(
            title: "确认导入",
            message: "将导入 \(recordCount) 条打卡记录，这将覆盖现有数据。确定要继续吗？",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定导入", style: .destructive) { [weak self] _ in
            self?.performImport()
        })
        
        present(alert, animated: true)
    }
    
    private func performImport() {
        // 获取导入的数据并传递给TimeRecordManager
        if let data = UserDefaults.standard.data(forKey: "TimeRecords"),
           let records = try? JSONDecoder().decode([TimeRecord].self, from: data) {
            
            // 创建TimeRecordManager实例并导入数据
            let timeRecordManager = TimeRecordManager()
            timeRecordManager.importRecords(records)
            
            // 发送通知，通知其他视图更新
            NotificationCenter.default.post(name: NSNotification.Name("ImportDataRequested"), object: nil)
            
            showAlert(title: "导入成功", message: "已成功导入 \(records.count) 条打卡记录")
        } else {
            showAlert(title: "导入失败", message: "数据格式错误")
        }
    }
    
    // MARK: - 关于软件部分方法
    @objc private func versionButtonTapped() {
        let alert = UIAlertController(
            title: "版本信息",
            message: "Mtimes 时间记录应用\n版本: 1.0.0\n构建日期: 2025年8月\n开发者: Mclarenlife",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func feedbackButtonTapped() {
        let alert = UIAlertController(
            title: "反馈联系",
            message: "如果您有任何问题、建议或反馈，请通过以下方式联系我们：\n\n邮箱: xiangjinleee@gmail.com\n\n我们会尽快回复您的邮件。",
            preferredStyle: .alert
        )
        
        // 添加复制邮箱按钮
        alert.addAction(UIAlertAction(title: "复制邮箱", style: .default) { _ in
            UIPasteboard.general.string = "support@mtimes.com"
            self.showAlert(title: "已复制", message: "邮箱地址已复制到剪贴板")
        })
        
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate
extension SettingsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        do {
            let jsonData = try Data(contentsOf: url)
            let exportData = try JSONDecoder().decode(ExportData.self, from: jsonData)
            
            // 显示确认对话框
            showImportConfirmationAlert(recordCount: exportData.records.count)
            
            // 保存导入的数据到UserDefaults
            if let encoded = try? JSONEncoder().encode(exportData.records) {
                UserDefaults.standard.set(encoded, forKey: "TimeRecords")
            }
            
        } catch {
            showAlert(title: "导入失败", message: "文件格式错误或损坏: \(error.localizedDescription)")
        }
    }
}

// MARK: - 导出数据结构
struct ExportData: Codable {
    let version: String
    let exportDate: Date
    let records: [TimeRecord]
}
