//
//  ViewController.swift
//  Passio-Nutrition-AI-iOS-UI-Module
//
//  Created by Nikunj Prajapati on 21/05/24.
//

import UIKit
import PassioNutritionAISDK

class NutritionEntryViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelTagline: UILabel!
    @IBOutlet weak var labelDownloading: UILabel!
    @IBOutlet weak var buttonStartNutritionAI: UIButton!

    private var passioConfig = PassioConfiguration(key: PassioExternalConnector.shared.passioKeyForSDK)
    private var passioStatus: PassioStatus?

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonStartNutritionAI.isHidden = true
        navigationController?.navigationBar.isHidden = true
        labelTagline.text = """
        Passio Nutrition-AI
        Technology Demonstration
        """
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configurePassioSDK()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
    }

    @IBAction func onStartNutritionAI(_ sender: UIButton) {
        startPassioModule()
    }

    @objc private func didBecomeActive() {

        if let sdkMode = passioStatus?.mode,
           sdkMode != .isReadyForDetection {
            configurePassioSDK()
        }
    }

    func configurePassioSDK() {

        let passioSDK = PassioNutritionAI.shared
        activityIndicator.startAnimating()
        passioConfig.debugMode = 0 // 0 means no logging/print, change to 31418, -333 or 1 for logging
        passioSDK.statusDelegate = self
        passioConfig.sdkDownloadsModels = true
        passioSDK.configure(passioConfiguration: passioConfig) { [weak self] status in
            guard let self else { return }
            self.passioStatus = status
        }
    }

    func configUIAfterStateChange(status: PassioStatus) {

        DispatchQueue.main.async { [self] in
            switch status.mode {
            case .isReadyForDetection:
                activityIndicator.stopAnimating()
                labelDownloading.isHidden = true
                buttonStartNutritionAI.isHidden = false
            case .isBeingConfigured:
                break
            case .failedToConfigure:
                labelDownloading.text = "SDK failed to configure"
            case .isDownloadingModels:
                labelDownloading.text = "SDK is downloading files"
            case .notReady:
                labelDownloading.text = "SDK is not ready"
            @unknown default:
                break
            }
        }
    }

    @objc private func startPassioModule(showLog: Bool = false, firebaseMode: Bool = false) {

        navigationController?.navigationBar.isHidden = false

        let passioExternalConnector = PassioExternalConnector.shared
        passioExternalConnector.firebaseMode = firebaseMode

        let vc = NutriationUICoordinator.getHomeTabbarViewController()
        PassioInternalConnector.shared.startPassioAppModule(passioExternalConnector: passioExternalConnector,
                                                     presentingViewController: self,
                                                     withViewController: vc,
                                                     withDismissAnimation: true,
                                                     passioConfiguration: passioConfig) { passioStatus in
            // print("PassioStatus:- \(passioStatus)")
        }
    }
}

// MARK: - PassioStatus Delegate
extension NutritionEntryViewController: PassioStatusDelegate {

    func passioStatusChanged(status: PassioStatus) {
        configUIAfterStateChange(status: status)
    }

    func passioProcessing(filesLeft: Int) {
        DispatchQueue.main.async {
            self.labelDownloading.text = "Files left to Process \(filesLeft)"
        }
    }

    func completedDownloadingAllFiles(filesLocalURLs: [FileLocalURL]) {
        DispatchQueue.main.async {
            self.labelDownloading.text = "Completed downloading all files"
        }
    }

    func completedDownloadingFile(fileLocalURL: FileLocalURL, filesLeft: Int) {
        DispatchQueue.main.async {
            self.labelDownloading.text = "Files left to download \(filesLeft)"
        }
    }

    func downloadingError(message: String) {
        print("Downloading Error:- \(message)")
        DispatchQueue.main.async {
            self.labelDownloading.text = "\(message)"
            self.activityIndicator.stopAnimating()
        }
    }
}
