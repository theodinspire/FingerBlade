//
//  AppDelegate.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 1/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

import AWSCore
//import AWSCognito

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //  AWS set up
        //  Cognito
        var awsPoolID: String?
        var awsCogRegion: String?
        //  S3
        var awsBucket: String?
        var awsS3Region: String?
        
        var keyDictionary: [String : Any]?
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keyDictionary = NSDictionary(contentsOfFile: path) as? [String : Any]
        }
        if let keyDict = keyDictionary, let s3 = keyDict["S3"] as? [String: String], let cognito = keyDict["Cognito"] as? [String: String] {
            awsPoolID = cognito["UserPoolID"]
            awsCogRegion = cognito["Region"]
            awsBucket = s3["Bucket"]
            awsS3Region = s3["Region"]
        }
        
        //  Setting up AWS Service Configuration
        //let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast2, identityPoolId: awsPoolID!)
        //let configuration = AWSServiceConfiguration(region: .USEast2, credentialsProvider: credentialsProvider)
        
        //AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        
        //  End set up
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

