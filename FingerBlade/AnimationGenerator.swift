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
    let lefty: Bool
    
    var dotSize: CGFloat = 40
    var lineWeight: CGFloat = 20
    
    var dotDuration: CFTimeInterval = 1.5
    var strokeDuration: CFTimeInterval = 3
    var strokeChaseDelay: CFTimeInterval = 1
    
    var strokeColor = UIColor.darkGray.cgColor
    
    init(withPathGenerator generator: CutPathGenerator) {
        pathGenerator = generator
        lefty = generator.lefty
    }
    
    
    //  Animation for a solo tap
    func tapAnimation(forCut cut: CutLine) -> CAShapeLayer {
        let layer = ShapeLayer()
        layer.path = pathGenerator.path(for: cut).cgPath
        
        let grow = pointAnimation()
        let dot = pointStroke()
        dot.repeatCount = .greatestFiniteMagnitude
        
        layer.add(grow, forKey: "lineWidth")
        layer.add(dot, forKey: "strokeEnd")
        
        return layer
    }
    
    func swipeAnimation(forCut cut: CutLine) -> CAShapeLayer {
        let layer = ShapeLayer()
        layer.path = pathGenerator.path(for: cut).cgPath
        
        let strokeEndAnimation = strokeEnd()
        let strokeStartAnimation = strokeStart()
        
        layer.add(strokeEndAnimation, forKey: "strokeEnd")
        layer.add(strokeStartAnimation, forKey: "strokeStart")
        
        return layer
    }
    
    func tapSwipeAnimation(forCut cut: CutLine) -> CAShapeLayer {
        let layer = ShapeLayer()
        layer.path = pathGenerator.path(for: cut).cgPath
        
        let lineWidthAnimation = pointAnimation(long: true)
        let strokeEndAnimation = strokeEnd(long: true)
        let strokeStartAnimation = strokeStart(long: true)
        
        layer.add(lineWidthAnimation, forKey: "lineWidth")
        layer.add(strokeEndAnimation, forKey: "strokeEnd")
        layer.add(strokeStartAnimation, forKey: "strokeStart")
        
        return layer
    }
    
    private func pointAnimation(long: Bool = false) -> CAAnimation {
        let grow = CASpringAnimation(keyPath: "lineWidth")
        grow.fromValue = lineWeight
        grow.toValue = dotSize
        grow.duration = dotDuration / 2
        grow.autoreverses = true
        grow.mass = 2
        grow.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        if long {
            let group = CAAnimationGroup()
            group.duration = dotDuration + strokeDuration
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            group.repeatCount = .greatestFiniteMagnitude
            group.animations = [grow]
            
            return group
        }   //  else
        
        grow.repeatCount = .greatestFiniteMagnitude
        return grow
    }
    
    private func pointStroke() -> CAAnimation {
        let dot = CABasicAnimation(keyPath: "strokeEnd")
        dot.fromValue = CGFloat.leastNonzeroMagnitude
        dot.toValue = CGFloat.leastNonzeroMagnitude
        dot.duration = self.dotDuration
        
        return dot
    }
    
    private func strokeEnd(long: Bool = false) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat.leastNonzeroMagnitude
        animation.toValue = 1
        animation.beginTime = long ? dotDuration * 0.7 : 0
        animation.duration = strokeDuration - strokeChaseDelay
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = strokeDuration + ( long ? dotDuration : 0 )
        group.repeatCount = .greatestFiniteMagnitude
        group.animations = long ? [pointStroke(), animation] : [animation]
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return group
    }
    
    private func strokeStart(long: Bool = false) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = 0
        animation.toValue = 1
        animation.beginTime = self.strokeChaseDelay + (long ? dotDuration : 0)
        animation.duration = self.strokeDuration - self.strokeChaseDelay
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = self.strokeDuration + (long ? dotDuration : 0)
        group.repeatCount = .greatestFiniteMagnitude
        group.animations = [animation]
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return group
    }
    
    private func ShapeLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        layer.strokeColor = strokeColor
        layer.lineCap = kCALineCapRound
        layer.lineWidth = lineWeight
        layer.fillColor = UIColor.clear.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
        
        return layer
    }
}
