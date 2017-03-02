//
//  CutDrawPath.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 3/1/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

struct CutDrawPath {
    let start: CGPoint
    let path: [CGPoint]
    
    init(start beginnging: CGPoint, path steps: [CGPoint]) {
        start = beginnging
        path = steps
    }
    
    init(path steps: [CGPoint]) {
        guard steps.count >= 1 else {
            start = CGPoint(x: 0, y: 0)
            path = []
            return
        }
        
        start = steps.first!
        path = [CGPoint](steps.suffix(1))
    }
    
    init(string: String) {
        let steps = createCGPointArray(from: string)
        self.init(path: steps)
    }
    
    static func getExemplar(cut: CutLine, lefty: Bool = false) -> CutDrawPath {
        switch cut {
        case .fendManTut:
            return CutDrawPath(string: "(27.0, 52.0), (31.0, 57.0), (40.0, 72.0), (61.0, 104.0), (88.0, 146.0), (118.0, 191.0), (151.0, 239.0), (181.0, 290.0), (207.0, 335.0), (228.0, 376.0), (248.0, 417.0), (269.0, 446.0), (288.0, 466.0), (305.0, 482.0), (317.0, 493.0), (328.0, 502.0), (332.0, 508.0), (334.0, 510.0), (335.0, 510.0), (335.0, 511.0), (341.0, 520.0)")
        default:
            return CutDrawPath(path: [])
        }
    }
}

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
