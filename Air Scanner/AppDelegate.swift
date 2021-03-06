//
//  AppDelegate.swift
//  Air Scanner
//
//  Created by User on 27.04.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseFirestore
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = "698147414199-eosb76hiiqo6seqdr9jog9hbjulrofrh.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        configureAppearance()
        
        Authentication.refreshToken()
        
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
    
    private func configureAppearance() {
        UITabBar.appearance().barTintColor = UIColor(named: "TabBarBackground")
        
        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(named: "Background")
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = .clear
        let bgView = UIView()
        bgView.backgroundColor = .clear
        UITableViewCell.appearance().selectedBackgroundView = bgView
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "MainButton")
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14),
                                                                .foregroundColor: UIColor.white.withAlphaComponent(0.6) ],
                                                               for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 14),
                                                                .foregroundColor: UIColor.white],
                                                               for: .selected)
    }
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
          return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        Authentication.signIn(with: credential, user: user)
    }
}

