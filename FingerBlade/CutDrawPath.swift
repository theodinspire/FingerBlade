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
        
        var tmp = steps
        
        start = tmp.remove(at: 0)
        path = tmp
    }
    
    init(string: String) {
        let steps = createCGPointArray(from: string)
        self.init(path: steps)
    }
    
    static func getExemplar(cut: CutLine, lefty: Bool = false) -> CutDrawPath {
        switch cut {
        case .fendManTut:
            return CutDrawPath(string: "(35.0, 80.0), (41.0, 86.0), (53.0, 106.0), (72.0, 139.0), (94.0, 177.0), (119.0, 217.0), (143.0, 258.0), (166.0, 298.0), (189.0, 334.0), (213.0, 366.0), (233.0, 401.0), (249.0, 434.0), (263.0, 456.0), (276.0, 474.0), (287.0, 489.0), (297.0, 501.0), (305.0, 511.0), (309.0, 516.0), (312.0, 519.0), (316.0, 521.0)")
        default:
            return CutDrawPath(path: [])
        }
    }
    
    func maxSpeed(bounds rect: CGRect) -> CGFloat {
        var maxSpeed: CGFloat = 0
        var prev = start
        
        for point in path {
            let dx = point.x - prev.x
            let dy = point.y - prev.y
            
            let speed = sqrt(dx * dx + dy * dy)
            
            maxSpeed = max(maxSpeed, speed)
            
            prev = point
        }
        
        return maxSpeed
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
