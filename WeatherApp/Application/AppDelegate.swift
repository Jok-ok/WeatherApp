//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Александр Воробей on 02.09.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeRootView()

        return true
    }

}

private extension AppDelegate {
    func initializeRootView(){
        window = UIWindow()
        let controller = CityViewController()
        let navigation = UINavigationController(rootViewController: controller)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
