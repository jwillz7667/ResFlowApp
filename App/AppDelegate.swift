// App/AppDelegate.swift

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize services or perform any setup after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Pause ongoing tasks, disable timers, etc.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Release shared resources, save user data, invalidate timers, etc.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Undo changes made when entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart tasks paused or not yet started while the application was inactive.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
    }
}
