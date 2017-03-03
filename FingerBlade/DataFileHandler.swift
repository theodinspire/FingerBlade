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
    static let dateFormat = standardDateFormatter()
    
    var fileManager = FileManager()
    var tmpDirectory = NSTemporaryDirectory()
    let filename: String
    
    var header = ""
    var body = ""
    var sent = false
    
    convenience init() {
        self.init(filename: standardDateFormatter().string(from: Date()))
    }
    
    init(filename: String) {
        self.filename = filename
        
        header += (UIDevice.current.identifierForVendor?.description ??
            "Unidentified device") + "\n"
        header += UIDevice.current.model + "\n"
        if let email = UserDefaults.standard.string(forKey: "Email") {
            header += email + "\n"
        }
        if let hand = UserDefaults.standard.string(forKey: "Hand") {
            header += "Sword-hand: " + hand + "\n"
        }
        header += Date().description + "\n\n"
    }
    
    func addSample(store: SampleStore) {
        body += store.getVerboseString()
    }
    
    func writeSample(store: SampleStore) {
        addSample(store: store)
        
        let path = tmpDirectory.appending(filename)
        
        let toWrite = header + body
        
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
