//
//  AWSRegionType.swift
//  FingerBlade
//
//  Created by Cormack on 2/9/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation
import AWSCore

extension AWSRegionType {
    static func getRegionType(from string: String?) -> AWSRegionType? {
        if let str = string {
            switch str.lowercased() {
            case "us-east-1":
                return .USEast1
            case "us-east-2":
                return .USEast2
            case "us-west-1":
                return .USWest1
            case "us-west-2":
                return .USWest2
            case "ca-central-1":
                return .CACentral1
            case "ap-south-1":
                return .APSouth1
            case "ap-northeast-2":
                return .APNortheast2
            case "ap-southeast-1":
                return .APSoutheast1
            case "ap-southeast-2":
                return .APSoutheast2
            case "ap-northeast-1":
                return .APNortheast1
            case "eu-central-1":
                return .EUCentral1
            case "eu-west-1":
                return .EUWest1
            case "eu-west-2":
                return .EUWest2
            case "sa-east-1":
                return .SAEast1
            //  Not above? then nil
            default:
                return nil
            }
        } else { return nil }
    }
}
