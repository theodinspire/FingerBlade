//
//  KeyRing.swift
//  FingerBlade
//
//  Created by Cormack on 2/9/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation
import AWSCore

class KeyRing {
    //  Fields
    //  Cognito
    private var awsCognitoRegion: AWSRegionType?
    private var awsCognitoUserPool: String?
    //  S3
    private var awsS3Region: AWSRegionType?
    private var awsS3Bucket: String?
    
    private var isSetUp = false
    
    //  Singleton
    static private let instance = KeyRing()
    
    //  Singleton init
    private init() {
        var keyDictionary: [String : Any]?
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keyDictionary = NSDictionary(contentsOfFile: path) as? [String : Any]
        }
        if let keyDict = keyDictionary, let s3 = keyDict["S3"] as? [String: String], let cognito = keyDict["Cognito"] as? [String: String] {
            awsCognitoUserPool = cognito["UserPoolID"]
            awsCognitoRegion = AWSRegionType.getRegionType(from: cognito["Region"])
            awsS3Bucket = s3["Bucket"]
            awsS3Region = AWSRegionType.getRegionType(from: s3["Region"])
        }
        
        //  Setting up AWS Service Configuration
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: awsCognitoRegion!, identityPoolId: awsCognitoUserPool!)
        let configuration = AWSServiceConfiguration(region: awsS3Region!, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        isSetUp = true
    }
    
    //  Just making sure this is on
    static var setup: Bool {
        get {
            return instance.isSetUp
        }
    }
    
    //  Get things from the ring
    static var bucket: String? { get { return instance.awsS3Bucket } }
    static var s3Region: AWSRegionType? { get { return instance.awsS3Region } }
}
