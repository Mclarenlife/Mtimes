import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    private var timeRecordManager = TimeRecordManager()
    private var currentViewController: UIViewController?
    
    private lazy var homeViewController: HomeViewController = {
        let vc = HomeViewController()
        vc.timeRecordManager = timeRecordManager
        return vc
    }()
    
    private lazy var statisticsViewController: StatisticsViewController = {
        let vc = StatisticsViewController()
        vc.timeRecordManager = timeRecordManager
        return vc
    }()
    
    private lazy var settingsViewController: SettingsViewController = {
        let vc = SettingsViewController()
        return vc
    }()
    
    private lazy var navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("首页", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var statisticsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("统计", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.addTarget(self, action: #selector(statisticsButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("设置", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showHomeView()
    }
    

    
    private func setupUI() {
        view.backgroundColor = UIColor.clear
        
        // 添加导航栏
        view.addSubview(navigationBar)
        navigationBar.addSubview(homeButton)
        navigationBar.addSubview(statisticsButton)
        navigationBar.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            navigationBar.heightAnchor.constraint(equalToConstant: 50),
            
            homeButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 30),
            homeButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            
            statisticsButton.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            statisticsButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            
            settingsButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -30),
            settingsButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
    }
    
    @objc private func homeButtonTapped() {
        showHomeView()
        updateButtonStates(selectedButton: homeButton, unselectedButtons: [statisticsButton, settingsButton])
    }
    
    @objc private func statisticsButtonTapped() {
        showStatisticsView()
        updateButtonStates(selectedButton: statisticsButton, unselectedButtons: [homeButton, settingsButton])
    }
    
    @objc private func settingsButtonTapped() {
        showSettingsView()
        updateButtonStates(selectedButton: settingsButton, unselectedButtons: [homeButton, statisticsButton])
    }
    
    private func updateButtonStates(selectedButton: UIButton, unselectedButtons: [UIButton]) {
        selectedButton.setTitleColor(UIColor.label, for: .normal)
        unselectedButtons.forEach { button in
            button.setTitleColor(UIColor.systemGray, for: .normal)
        }
    }
    
    private func showHomeView() {
        removeCurrentViewController()
        addChild(homeViewController)
        view.insertSubview(homeViewController.view, belowSubview: navigationBar)
        homeViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            homeViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        homeViewController.didMove(toParent: self)
        currentViewController = homeViewController
    }
    
    private func showStatisticsView() {
        removeCurrentViewController()
        addChild(statisticsViewController)
        view.insertSubview(statisticsViewController.view, belowSubview: navigationBar)
        statisticsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statisticsViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            statisticsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statisticsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statisticsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        statisticsViewController.didMove(toParent: self)
        currentViewController = statisticsViewController
    }
    
    private func showSettingsView() {
        removeCurrentViewController()
        addChild(settingsViewController)
        view.insertSubview(settingsViewController.view, belowSubview: navigationBar)
        settingsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            settingsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        settingsViewController.didMove(toParent: self)
        currentViewController = settingsViewController
    }
    
    private func removeCurrentViewController() {
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        currentViewController = nil
    }
}
