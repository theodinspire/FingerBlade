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
    
    
    /// Default constructor, uses date and GUID to title file
    convenience init() {
        self.init(filename: standardDateFormatter().string(from: Date()) + "." + (UIDevice.current.identifierForVendor?.description ?? "Anonymous") + ".txt")
    }
    
    
    /// Constructor: preps header of the file using User Defaults
    ///
    /// - Parameter filename: Targeted filename
    init(filename: String) {
        self.filename = filename
        
        header += (UIDevice.current.identifierForVendor?.description ??
            "Unidentified device") + "\n"
        header += UIDevice.current.model + "\n"
        header += "Device screen size: \(UIScreen.main.fixedCoordinateSpace.bounds.size)\n"
        if let email = UserDefaults.standard.string(forKey: "Email") {
            header += email + "\n"
        }
        if let hand = UserDefaults.standard.string(forKey: "Hand") {
            header += "Sword-hand: " + hand + "\n"
        }
        header += Date().description + "\n\n"
    }
    
    /// Preps a body from the corpus of samples
    ///
    /// - Parameter store: A Collection of cut samples
    private func addSample(store: SampleStore) {
        body += store.getVerboseString()
    }
    
    /// Writes a sample to file
    ///
    /// - Parameter store: Sample to be written
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
    
    /// Send written file to AWS S3
    func send() {
        Transmitter.upload(data: fileManager.contents(atPath: tmpDirectory.appending(filename)), named: filename)
    }
}
