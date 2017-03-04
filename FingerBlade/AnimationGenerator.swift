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
    
    init(withPathGenerator generator: CutPathGenerator) {
        pathGenerator = generator
    }
    
    //  Animation for a solo tap
    func tapAnimation() -> CAShapeLayer {
        let shapeLayer = ShapeLayer()
        shapeLayer.fillColor = fillColor
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: dotSize / 4, y: dotSize / 4, width: dotSize / 2, height: dotSize / 2)).cgPath
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
        position.fromValue = [0, 0]
        position.toValue = [-dotSize / 2, -dotSize / 2] //  It's the entire CAShapeLayer that's transforming
        position.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        position.duration = self.dotDuration / 2
        position.repeatCount = .greatestFiniteMagnitude
        position.autoreverses = true
        position.mass = 2
        
        shapeLayer.add(scale, forKey: "transform.scale")
        shapeLayer.add(position, forKey: "position")
        
        return shapeLayer
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
    
    func tapSwipeAnimation(forCut cut: CutLine) -> (CAShapeLayer, CAShapeLayer) {
        let swipeLayer = ShapeLayer()
        let tapLayer = ShapeLayer()
        
        //  Tap
        let start = pathGenerator.start(for: cut)
        tapLayer.fillColor = fillColor
        //tapLayer.path = UIBezierPath(ovalIn: CGRect(x: start.x - dotSize / 4, y: start.y - dotSize / 4, width: dotSize / 2, height: dotSize / 2)).cgPath
        
        let scale: CAAnimation = {
            let animation = CASpringAnimation(keyPath: "transform.scale")
            animation.fromValue = 1
            animation.toValue = 2
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            animation.duration = self.dotDuration / 2
            animation.repeatCount = 1
            animation.autoreverses = true
            animation.mass = 2
            
            let group = CAAnimationGroup()
            group.duration = self.dotDuration + self.strokeDuration
            group.repeatCount = .greatestFiniteMagnitude
            group.animations = [animation]
         
            return group
        }()
        
        let position: CAAnimation = {
            let animation = CASpringAnimation(keyPath: "position")
            animation.fromValue = [0, 0]
            animation.toValue = [-start.x, -start.y] //  It's the entire CAShapeLayer that's transforming
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            animation.duration = self.dotDuration / 2
            animation.repeatCount = 1
            animation.autoreverses = true
            animation.mass = 2
            
            let group = CAAnimationGroup()
            group.duration = self.dotDuration + self.strokeDuration
            group.repeatCount = .greatestFiniteMagnitude
            group.animations = [animation]
            
            return group
        }()
        
        //tapLayer.add(scale, forKey: "transform.scale")
        //tapLayer.add(position, forKey: "position")
        
        //  Swipe
        let path = pathGenerator.path(for: cut)
        swipeLayer.path = path.cgPath
        swipeLayer.lineWidth = lineWeight
        
        let lineWidthAnimation: CAAnimation = {
            let grow = CASpringAnimation(keyPath: "lineWidth")
            grow.fromValue = self.lineWeight
            grow.toValue = self.dotSize
            grow.duration = self.dotDuration / 2
            grow.autoreverses = true
            grow.mass = 2
            grow.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let group = CAAnimationGroup()
            group.duration = self.dotDuration + self.strokeDuration
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            group.repeatCount = .greatestFiniteMagnitude
            group.animations = [grow]
            
            return group
        }()
        
        let strokeEndAnimation: CAAnimation = {
            let dot = CABasicAnimation(keyPath: "strokeEnd")
            dot.fromValue = CGFloat.leastNonzeroMagnitude
            dot.toValue = CGFloat.leastNonzeroMagnitude
            dot.duration = self.dotDuration
            
            let stroke = CABasicAnimation(keyPath: "strokeEnd")
            stroke.fromValue = CGFloat.leastNonzeroMagnitude
            stroke.toValue = 1
            stroke.beginTime = self.dotDuration
            stroke.duration = self.strokeDuration - self.strokeChaseDelay
            stroke.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let group = CAAnimationGroup()
            group.duration = self.dotDuration + self.strokeDuration
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            group.repeatCount = .greatestFiniteMagnitude
            group.animations = [dot, stroke]
            
            return group
        }()
        
        let strokeStartAnimation: CAAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeStart")
            animation.fromValue = 0
            animation.toValue = 1
            animation.beginTime = self.strokeChaseDelay + self.dotDuration
            animation.duration = self.strokeDuration - self.strokeChaseDelay
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let group = CAAnimationGroup()
            group.duration = self.dotDuration + self.strokeDuration
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            group.repeatCount = .greatestFiniteMagnitude
            group.animations = [animation]
            
            return group
        }()
        
        swipeLayer.add(lineWidthAnimation, forKey: "lineWidth")
        swipeLayer.add(strokeEndAnimation, forKey: "strokeEnd")
        swipeLayer.add(strokeStartAnimation, forKey: "strokeStart")
        
        //  Combine
        return (tapLayer, swipeLayer)
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
