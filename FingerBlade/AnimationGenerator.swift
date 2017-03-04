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
    
    var dotDuration: CFTimeInterval = 1.5
    var strokeDuration: CFTimeInterval = 3
    var strokeChaseDelay: CFTimeInterval = 1
    
    var strokeColor = UIColor.darkGray.cgColor
    var fillColor = UIColor.darkGray.cgColor
    
    private var tapShapeLayer = CAShapeLayer()
    var tapEnded = false
    
    init(withPathGenerator generator: CutPathGenerator) {
        pathGenerator = generator
    }
    
    //  Animation for a solo tap
    func tapAnimation() -> CAShapeLayer {
        tapEnded = false
        tapShapeLayer = ShapeLayer()
        tapShapeLayer.fillColor = fillColor
        tapShapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: dotSize / 2, height: dotSize / 2)).cgPath
        //shapeLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: dotSize / 2, height: dotSize / 2)).cgPath
        
        let scale = CASpringAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 2
        scale.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        scale.duration = self.dotDuration / 2
        scale.repeatCount = .greatestFiniteMagnitude
        scale.autoreverses = true
        scale.mass = 2
        
        let position = CASpringAnimation(keyPath: "position")
        position.fromValue = [dotSize / 4, dotSize / 4]
        position.toValue = [0, 0]
        position.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        position.duration = self.dotDuration / 2
        position.repeatCount = .greatestFiniteMagnitude
        position.autoreverses = true
        position.mass = 2
        
        tapShapeLayer.add(scale, forKey: "transform.scale")
        tapShapeLayer.add(position, forKey: "position")
        
        return tapShapeLayer
    }
    
    func endTapAnimation() {
        CATransaction.begin()
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 1
        scale.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        scale.duration = 0.75
        scale.repeatCount = 1
        scale.autoreverses = false
        
        let position = CASpringAnimation(keyPath: "position")
        position.fromValue = [dotSize / 4, dotSize / 4]
        position.toValue = [dotSize / 4, dotSize / 4]
        position.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        position.duration = 0.75
        position.byValue = 1
        scale.autoreverses = false
        
        tapShapeLayer.add(scale, forKey: "transform.scale")
        tapShapeLayer.add(position, forKey: "position")
        
        CATransaction.setCompletionBlock { self.tapEnded = true }
        CATransaction.commit()
    }
    
    func swipeAnimation(forCut cut: CutLine) -> CAShapeLayer {
        let shapeLayer = ShapeLayer()
        shapeLayer.lineWidth = lineWeight
        shapeLayer.path = pathGenerator.path(for: cut).cgPath
        
        let strokeEndAnimation: CAAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = self.strokeDuration - self.strokeChaseDelay
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let group = CAAnimationGroup()
            group.duration = self.strokeDuration
            group.repeatCount = .greatestFiniteMagnitude
            group.animations = [animation]
            
            return group
        }()
        
        let strokeStartAnimation: CAAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeStart")
            animation.fromValue = 0
            animation.toValue = 1
            animation.beginTime = self.strokeChaseDelay
            animation.duration = self.strokeDuration - self.strokeChaseDelay
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let group = CAAnimationGroup()
            group.duration = self.strokeDuration
            group.repeatCount = .greatestFiniteMagnitude
            group.animations = [animation]
            
            return group
        }()
        
        shapeLayer.add(strokeEndAnimation, forKey: "strokeEnd")
        shapeLayer.add(strokeStartAnimation, forKey: "strokeStart")
        
        return shapeLayer
    }
    
    private func ShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        return shapeLayer
    }
}
