//
//  AppDelegate.swift
//  SetreeApp
//
//  Created by HilalOruc on 3.02.2023.
//

import UIKit
import NotificationBannerSwift


var baseUSER: User?

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    private weak var userService: UserService? {
          return UserService()
      }
    
    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("Utils.isLoggedIn() : ",Utils.isLoggedIn())
        
        // Create a window that is the same size as the screen
        window = UIWindow(frame: UIScreen.main.bounds)

        if(Utils.isLoggedIn()){
            
            self.userService?.getUser(){ result in
                switch result {
                case .success(let user):
                    baseUSER = user
                    print("baseUSER : ",baseUSER)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    self.window?.rootViewController = storyboard.instantiateInitialViewController()
                                
                    
                    let banner = GrowingNotificationBanner(title: "Dont need to login :)", subtitle: "Your session has not expired.", style: .info)
                    banner.show()
                     
                case .failure(let error):
                    LocalStorage.setItem("baseTOKEN", value:0)
                    
                    let storyBoard = UIStoryboard.init(name: "Auth" , bundle: nil)
                    self.window?.rootViewController = storyBoard.instantiateInitialViewController()
                    
                    Banner.showErrorBanner(with: error)
                }
            }
                    
        } else{
            let storyBoard = UIStoryboard.init(name: "Auth" , bundle: nil)
            self.window?.rootViewController = storyBoard.instantiateInitialViewController()

        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

