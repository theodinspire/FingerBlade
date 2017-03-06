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
    
    var dotDuration: CFTimeInterval = 0.75
    var strokeDuration: CFTimeInterval = 1.33
    var strokeChaseDelay: CFTimeInterval = 0.67
    
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
    
    func wordSwipeAnimation(forCut cut: CutLine, long: Bool = false) -> CAAnimation {
        let pathStart = swipeWordStartPoint(forCut: cut)
        
        let pathStartPlus: CGPoint = {
            var point = pathStart
            point.x += CGFloat.leastNonzeroMagnitude
            point.y += CGFloat.leastNonzeroMagnitude
            return point
        }()
        
        let pathMid = swipeWordRestPoint(forCut: cut)
        
        let pathMidPlus: CGPoint = {
            var point = pathMid
            point.x += CGFloat.leastNonzeroMagnitude
            point.y += CGFloat.leastNonzeroMagnitude
            return point
        }()
        
        let wordBegin = UIBezierPath()
        wordBegin.move(to: pathStart)
        wordBegin.addLine(to: pathStartPlus)
        
        let wordPath = UIBezierPath()
        wordPath.move(to: pathStartPlus)
        wordPath.addLine(to: pathMid)
        
        let wordPause = UIBezierPath()
        wordPause.move(to: pathMid)
        wordPause.addLine(to: pathMidPlus)
        
        let animation: CAAnimation = {
            let duration = self.strokeDuration - self.strokeChaseDelay
            
            let begin = CAKeyframeAnimation(keyPath: "position")
            begin.path = wordBegin.cgPath
            begin.duration = long ? self.dotDuration : 0
            
            let movement = CAKeyframeAnimation(keyPath: "position")
            movement.path = wordPath.cgPath
            movement.beginTime = long ? self.dotDuration : 0
            movement.duration = duration
            
            let pause = CAKeyframeAnimation(keyPath: "position")
            pause.path = wordPause.cgPath
            pause.beginTime = duration + ( long ? self.dotDuration : 0 )
            
            let group = CAAnimationGroup()
            group.animations = [begin, movement, pause]
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            group.duration = self.strokeDuration + ( long ? self.dotDuration : 0 )
            
            return group
        }()
        
        return animation
    }
    
    func swipeWordStartPoint(forCut cut: CutLine) -> CGPoint {
        var point = pathGenerator.start(for: cut)
        if lefty { point.x += dotSize * 1.5
        } else /* righty */ { point.x -= dotSize * 1.5 }
        return point
    }
    
    func swipeWordRestPoint(forCut cut: CutLine) -> CGPoint {
        let pathStart = swipeWordStartPoint(forCut: cut)
        
        let pathEnd: CGPoint = {
            var point = pathGenerator.end(for: cut)
            if lefty { point.x += dotSize * 1.5
            } else /* righty */ { point.x -= dotSize * 1.5 }
            return point
        }()
        
        var point = CGPoint()
        point.x = (pathStart.x + pathEnd.x) / 2
        point.y = (pathStart.y + pathEnd.y) / 2
        return point
    }
    
    private func pointAnimation(long: Bool = false) -> CAAnimation {
        let grow = CABasicAnimation(keyPath: "lineWidth")
        grow.fromValue = lineWeight
        grow.toValue = dotSize
        grow.duration = dotDuration / 2
        grow.autoreverses = true
        grow.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
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
