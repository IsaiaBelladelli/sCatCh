
import UIKit
import Firebase
import OSLog

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Logger.runCycle.debug("\(type(of: self)): \(#function): Configure Firebase")
    
    FirebaseApp.configure()
    
    return true
  }
}
