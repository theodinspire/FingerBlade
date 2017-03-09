//
//  Global.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 3/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

//  Strings for UserDefaults
let HAND = "Hand"
let EMAIL = "Email"
let STORE = "CurrentStore"
let COMPLETE = "InitialSampleCompleted"

//  Create array of CGPoints from a string

/// Create an array of CGPoints from a comma separated string of parenthetical cartesion coordinates
/// Is this even used?
///
/// - Parameter string: String to be decoded
/// - Returns: Point array
func createCGPointArray(from string: String) -> [CGPoint] {
    let split = string.replacingOccurrences(of: "(", with: "").components(separatedBy: "), ")
    var array = [CGPoint]()
    
    for item in split {
        let pair = item.replacingOccurrences(of: ")", with: "").components(separatedBy: ", ")
        
        guard pair.count == 2, let x = Double(pair[0]), let y = Double(pair[1]) else {
            break
        }
        
        array.append(CGPoint(x: x, y: y))
    }
    
    return array
}

/// A standard date formatter, e.g. 20170307.1804 is the moment I wrote this: 7 Mar 2017, 18:04 UTC
///
/// - Returns: Date formatter
func standardDateFormatter() -> DateFormatter {
    let format = DateFormatter()
    format.dateFormat = "yyyyMMdd.HHmm"
    
    return format
}

/// Flip a ratio point around x = 0.5, making the left right and the right wrong
///
/// - Parameter original: Original point
/// - Returns: Translated point
func mirror(point original: CGPoint) -> CGPoint {
    return CGPoint(x: 1 - original.x, y: original.y)
}

/// Validate a string as a valid email address
///
/// - Parameter email: Candidate address
/// - Returns: true if a valid address, false otherwise
func validateEmail(of email: String?) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    return email?.range(of: emailRegEx, options: .regularExpression) != nil
}
