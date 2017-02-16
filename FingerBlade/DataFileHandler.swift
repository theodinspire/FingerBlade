//
//  DataFileHandler.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 2/15/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit
import AWSS3

class DataFileHandler {
    var fileManager = FileManager()
    var tmpDirectory = NSTemporaryDirectory()
    let filename: String
    
    var header = ""
    var sent = false
    
    init(filename: String) {
        self.filename = filename
        
        header += (UIDevice.current.identifierForVendor?.description ??
            "Unidentified device") + "\n"
        header += Date().description + "\n\n"
    }
    
    func writeSample(store: SampleStore) {
        let path = tmpDirectory.appending(filename)
        
        let toWrite = header + store.getVerboseString()
        
        //  Writing file
        do {
            try toWrite.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            print("File written")
        } catch {
            print("File did not write correctly")
        }
    }
    
    func send() {
        let transferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityUploadExpression()
        let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock = { (task, error) -> Void in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed with error: \(error)")
                } else {
                    print("Successful upload")
                }
            }
        }
        
        let data = fileManager.contents(atPath: tmpDirectory.appending(filename))
        
        if let data = data {
            transferUtility.uploadData(
                data,
                bucket: KeyRing.bucket!,
                key: filename,
                contentType: "text/plain",
                expression: expression,
                completionHandler: completionHandler).continueWith { (task) -> AnyObject! in
                    if let error = task.error {
                        print("Error: \(error.localizedDescription)")
                    }
                    
                    if let _ = task.result {
                        print("Upload Starting!")
                    }
                    
                    return nil
            }
        }
    }
}
