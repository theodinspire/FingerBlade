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
        Transmitter.upload(data: fileManager.contents(atPath: tmpDirectory.appending(filename)), named: filename)
    }
}
