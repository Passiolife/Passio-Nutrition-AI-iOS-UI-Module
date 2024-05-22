
# Passio-Nutrition-AI-iOS-UI-Module

### How to integrate Nutrition-UI module to your current Xcode Project.

> For reference, please check `NutritionEntryViewController`  class in Xcode Project. 
***Note:*** Don't forget to add `PassioNutritionAISDK`, `FSCalendar`, `SwiftyMarkdown` and `SwipeCellKit` via Swift Package Manager to your current Xcode Project.

1. Create instance of `PassioConfiguration`
    ***Note:*** You can create your own external PassioConnector class or use the provided one. You need to pass Passio key in PassioConfiguration
    ```swift
    PassioConfiguration(key: PassioExternalConnector.shared.passioKeyForSDK)
    ```
2. Call `startPassioAppModule` method of `PassioInternalConnector` class using shared instance
***Note:*** After the PassioNutrition AI SDK has been successfully initialised, call this method by tapping the `UIButton`.
	```swift
	// Instantiate HomeTabBar Controller (Passio's Nutrition UI module)
    let vc = NutriationUICoordinator.getHomeTabbarViewController()
    // Use this method to navigate to Passio's Nutrition UI module
    PassioInternalConnector.shared.startPassioAppModule(passioExternalConnector: passioExternalConnector,
                                                presentingViewController: self,
                                                withViewController: vc,
                                                withDismissAnimation: true,
                                                passioConfiguration: passioConfig) { passioStatus in
        print("PassioStatus:- \(passioStatus)")
   }
   ```
