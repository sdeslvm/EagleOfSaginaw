
import SwiftUI

@main
struct DesertEagleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            Loading()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if GameManager.shared.isGreetingShowing {
            return .allButUpsideDown
        } else {
            return .landscape
        }
    }
}

