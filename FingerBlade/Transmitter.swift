//
//  Transmitter.swift
//  FingerBlade
//
//  Created by Cormack on 2/16/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

import AWSS3

class Transmitter {
    static let transferUtility = AWSS3TransferUtility.default()
    static let expression = AWSS3TransferUtilityUploadExpression()
    static var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock =
        { (task, error) -> Void in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed with error: \(error)")
                } else {
                    print("Successful upload")
                }
            }
    }
    
    
    /// Sends data to AWS S3 bucket
    ///
    /// - Parameters:
    ///   - data: Data to be uploaded
    ///   - filename: Key to place the data under
    static func upload(data: Data?, named filename: String) {
        if KeyRing.setup {
            if let data = data {
                transferUtility.uploadData(data, bucket: KeyRing.bucket!, key: filename, contentType: "text/plain", expression: expression, completionHandler: completionHandler)
            } else {
                print("Data not valid")
            }
        } else {
            print("The AWS connection has not been established. Transmission aborted")
        }
    }
}
