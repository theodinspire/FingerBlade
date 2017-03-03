//
//  CutView.swift
//  FingerBlade
//
//  Created by Cormack on 3/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class CutView: UIView {
    var cut: CutLine = .punCav
    
    var minLineWidth: CGFloat = 5 // Cannot be zero
    var maxLineWidth: CGFloat = 15
    
    var targetColor = UIColor.black

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //  REMOVE
        let normalize = { (point: CGPoint) -> CGPoint in
            return CGPoint(x: point.x / self.bounds.width, y: point.y / self.bounds.height)
        }
        
        let mirror = { (point: CGPoint) -> CGPoint in
            return CGPoint(x: 1 - point.x, y: point.y)
        }
        
        // Drawing code
        let targetPath = CutDrawPath.getExemplar(cut: cut)
        
        targetColor.set()
        
        var prev = targetPath.start
        var lastSpeed: CGFloat = 7
        
        var norm = normalize(prev)
        var normList = String(describing: norm)
        var flipList = String(describing: mirror(norm))
        
        let deltaWidth = maxLineWidth - minLineWidth
        let maxSpeed = targetPath.maxSpeed(bounds: bounds)
        
        for point in targetPath.path {
            norm = normalize(point)
            normList += ", " + String(describing: norm)
            flipList += ", " + String(describing: mirror(norm))
            
            let dx = point.x - prev.x
            let dy = point.y - prev.y
            
            let speed = sqrt(dx * dx + dy * dy)
            let deltaSpeed = speed - lastSpeed
            
            var tmp = prev
            
            let steps = 10
            
            for i in 1...steps {
                //  Initialize step coefficient
                let stepChange = CGFloat(i) / CGFloat(steps)
                
                //  Set start of stroke
                let uiPath = UIBezierPath()
                uiPath.lineCapStyle = .round
                uiPath.move(to: tmp)
                
                //  Set line width
                let changedSpeed = lastSpeed + deltaSpeed * stepChange
                let normSpeed = changedSpeed / maxSpeed
                //  Use for narrow ends and wide middles
                //let lineWidth = deltaWidth * normSpeed + minLineWidth
                //  Use for wide ends and narrow middles
                let lineWidth = maxLineWidth - deltaWidth * normSpeed
                uiPath.lineWidth = lineWidth
                
                let x = prev.x + dx * stepChange
                let y = prev.y + dy * stepChange
                
                let next = CGPoint(x: x, y: y)
                uiPath.addLine(to: next)
                
                uiPath.stroke()
                
                tmp = next
            }
            
            prev = point
            lastSpeed = speed
        }
        
        print("Norm")
        print(normList)
        print("Flip")
        print(flipList)
    }

}
