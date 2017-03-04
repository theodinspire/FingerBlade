//
//  AnimationGenerator.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 3/4/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class AnimationGenerator {
    let pathGenerator: CutPathGenerator
    
    var dotSize: CGFloat = 40
    var lineWeight: CGFloat = 20
    
    var dotDuration: CGFloat = 1.5
    var strokeDuration: CGFloat = 3
    var strokeChaseDelay: CGFloat = 1
    
    var strokeColor = UIColor.darkGray.cgColor
    var fillColor = UIColor.darkGray.cgColor
    
    init(withPathGenerator generator: CutPathGenerator) {
        pathGenerator = generator
    }
    
    //  Animation for a solo tap
    func tapAnimation() -> CAShapeLayer {
        let shapeLayer = ShapeLayer()
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: dotSize, height: dotSize)).cgPath
        
        let scale = CASpringAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.5
        scale.toValue = 1
        scale.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        scale.duration = CFTimeInterval(self.dotDuration) / 2
        scale.repeatCount = .greatestFiniteMagnitude
        scale.autoreverses = true
        scale.mass = 2
        
        let position = CASpringAnimation(keyPath: "position")
        position.fromValue = [self.dotSize / 4, self.dotSize / 4]
        position.toValue = [0, 0]
        position.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        position.duration = CFTimeInterval(self.dotDuration) / 2
        position.repeatCount = .greatestFiniteMagnitude
        position.autoreverses = true
        position.mass = 2
        
        shapeLayer.add(scale, forKey: "transform.scale")
        shapeLayer.add(position, forKey: "position")
        
        return shapeLayer
    }
    
    private func ShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        return shapeLayer
    }
}
