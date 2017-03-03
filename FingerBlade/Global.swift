//
//  Global.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 3/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

//  Create array of CGPoints from a string
func createCGPointArray(from string: String) -> [CGPoint] {
    let split = string.replacingOccurrences(of: "(", with: "").components(separatedBy: "), ")
    var array = [CGPoint]()
    
    for item in split {
        let pair = item.replacingOccurrences(of: ")", with: "").components(separatedBy: ", ")
        
        guard pair.count == 2, let x = Double(pair[0]), let y = Double(pair[1]) else {
            break
        }
        
        array.append(CGPoint(x: x + 40, y: y + 10))
    }
    
    return array
}

//  Make a standard date formatter
func standardDateFormatter() -> DateFormatter {
    let format = DateFormatter()
    format.dateFormat = "yyyyMMdd.HHmm"
    
    return format
}

//  Flip a point's X coordinate around 0.5
func mirror(point original: CGPoint) -> CGPoint {
    return CGPoint(x: 1 - original.x, y: original.y)
}
