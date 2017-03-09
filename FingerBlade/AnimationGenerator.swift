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
    
    /// True if the user is left handed (or has reported themselves as such)
    let lefty: Bool
    
    /// Maximum size of the tap dot
    var dotSize: CGFloat = 40
    
    /// Line width of the swipe animation
    var lineWeight: CGFloat = 20
    
    /// Length of time for the dot's whole animation
    var dotDuration: CFTimeInterval = 0.75
    /// Length of time for the whole swipe animation
    var strokeDuration: CFTimeInterval = 1.33
    /// Delay before the tail of the swipe follows the head
    var strokeChaseDelay: CFTimeInterval = 0.67
    
    /// Animation color
    var strokeColor = UIColor.darkGray.cgColor
    
    /// Builds the animation generator
    ///
    /// - Parameter generator: The path generator to produce the curves from whence the cuts are animated
    init(withPathGenerator generator: CutPathGenerator) {
        pathGenerator = generator
        lefty = generator.lefty
    }
    
    /// Returns the animation for just the tap of a cut exemplar
    ///
    /// - Parameter cut: Cut to be displayed
    /// - Returns: Animation layer for the tap
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
    
    /// Returns the animation for just the swipe of a cut exemplar
    ///
    /// - Parameter cut: Cut to be displayed
    /// - Returns: Animation layer for the swipe
    func swipeAnimation(forCut cut: CutLine) -> CAShapeLayer {
        let layer = ShapeLayer()
        layer.path = pathGenerator.path(for: cut).cgPath
        
        let strokeEndAnimation = strokeEnd()
        let strokeStartAnimation = strokeStart()
        
        layer.add(strokeEndAnimation, forKey: "strokeEnd")
        layer.add(strokeStartAnimation, forKey: "strokeStart")
        
        return layer
    }
    
    /// Returns the animation for the tap and the swipe combined together
    ///
    /// - Parameter cut: Cut to be displayed
    /// - Returns: Animation layer for the tapswipe
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
    
    /// Creates an animation that the labels of swiped word will follow
    ///
    /// - Parameters:
    ///   - cut: Cut to be animated
    ///   - long: Whether or not a tap before it (true for tap, false for solo)
    /// - Returns: Animation layer for word animation
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
    
    /// Starting point for the word's animation path
    ///
    /// - Parameter cut: Cut to be animated
    /// - Returns: Starting point of the word's animation path
    func swipeWordStartPoint(forCut cut: CutLine) -> CGPoint {
        var point = pathGenerator.start(for: cut)
        if lefty { point.x += dotSize * 1.5
        } else /* righty */ { point.x -= dotSize * 1.5 }
        return point
    }
    
    /// Ending point for the word's animation path
    ///
    /// - Parameter cut: Cut to be animated
    /// - Returns: Ending point for the word's animation path
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
    
    /// Builds fade animation for the counter/success layer
    ///
    /// - Parameter duration: Time interval for the whole fade animation
    /// - Returns: Animation layer for the fade
    static func fadeAnimation(duration: CFTimeInterval) -> CALayer {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration / 2   //  Autoreverse will double it
        animation.autoreverses = true
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = true
        
        let layer = CALayer()
        layer.add(animation, forKey: "opacity")
        
        return layer
    }
    
    /// Builds scale animation for the counter/success layer
    ///
    /// - Parameter duration: Time interval of the whole scale animation
    /// - Returns: Animation layer for the scale
    static func scaleAnimation(duration: CFTimeInterval) -> CALayer {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = duration / 2   //  Autoreverse will double it
        animation.autoreverses = true
        animation.fromValue = 1
        animation.toValue = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = true
        
        let layer = CALayer()
        layer.add(animation, forKey: "transform.scale")
        
        return layer
    }
    
    /// Builds animation for the tap action
    ///
    /// - Parameter long: Whether or not the tap is followed by a swipe
    /// - Returns: Dot animation object
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
    
    /// Builds the stroke animation to display the tap action
    ///
    /// - Returns: Point position animation of the tap action
    private func pointStroke() -> CAAnimation {
        let dot = CABasicAnimation(keyPath: "strokeEnd")
        dot.fromValue = CGFloat.leastNonzeroMagnitude
        dot.toValue = CGFloat.leastNonzeroMagnitude
        dot.duration = self.dotDuration
        
        return dot
    }
    
    /// Bulids the head (called the end, idk why) of the swipe action animation
    ///
    /// - Parameter long: Whether there is a tap action preceding this animation
    /// - Returns: Animation of the head of the stroke
    private func strokeEnd(long: Bool = false) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = long ? CGFloat.leastNonzeroMagnitude : 0
        animation.toValue = 1 + CGFloat.leastNonzeroMagnitude
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
    
    /// Builds the chasing tail (called the start, idk why) of the swipe action animation
    ///
    /// - Parameter long: Whether there is a tap action preceding this animation
    /// - Returns: Animation of the chasing tail of the stroke
    private func strokeStart(long: Bool = false) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = 0
        animation.toValue = 1 + CGFloat.leastNonzeroMagnitude
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
    
    
    /// Preps a CAShapeLayer for animation use
    ///
    /// - Returns: Prepared shape layer
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
