//
//  UITapSwipeGestureRecognizer.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 1/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

import UIKit.UIGestureRecognizerSubclass

@IBDesignable class UITapSwipeGestureRecognizer: UIGestureRecognizer {
    //  Things to match the native libraries
    //  Tap requirements
    var numberOfTapsRequired: Int = 1
    var numberOfTapTouchesRequired: Int = 1
    //  Swipe Requirements
    var numberOfSwipeTouchesRequired: Int = 1
    var minimumSwipeThresholdDistance: CGFloat = 150
    
    //  Internal items
    var swipeMade = false
    
    var startingPoint: CGPoint = CGPoint()
    var trail: [CGPoint] = []
    
    //  Testing items
    
    /// Reset the recognizer to its virgin state
    override func reset() {
        super.reset()
        swipeMade = false
        state = .possible
        
        startingPoint = CGPoint()
        
        if !trail.isEmpty {
            trail.removeAll(keepingCapacity: true)
        }
    }
    
    /// Process the beginning of touches
    ///
    /// - Parameters:
    ///   - touches: Set of touches on the screen
    ///   - event: The event trigging this action?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        //  Handle Taps
        if (touches.first!.tapCount <= numberOfTapsRequired && numberOfTouches != numberOfTapTouchesRequired) ||
            (touches.first!.tapCount == numberOfTapsRequired + 1 && numberOfTouches != numberOfSwipeTouchesRequired) ||
            touches.first!.tapCount > numberOfTapsRequired + 1 {
            state = .failed
            return
        }
        
        //  Initialize Touching
        startingPoint = location(in: view?.window)
        
        if !trail.isEmpty {
            trail.removeAll(keepingCapacity: true)
        }
        trail.append(startingPoint)
    }
    
    /// Process the movement of fingers and fingerlike objects across the view
    ///
    /// - Parameters:
    ///   - touches: Set of finger locations
    ///   - event: Event driving the recognizer
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        //  Don't do anything if the state is currently failed
        if state == .failed {
            return
        }
        
        //  Moves shouldn't be happening on taps
        if touches.first!.tapCount != numberOfTapsRequired + 1 {
            state = .failed
            return
        }
        
        //  Check for correct number of touches already made
        let loc = location(in: view?.window)
        trail.append(loc)
        
        let deltaX = loc.x - /*trail.first!.x*/ startingPoint.x
        let deltaY = loc.y - /*trail.first!.y*/ startingPoint.y
        
        if !swipeMade && sqrt(deltaX * deltaX + deltaY * deltaY) >= minimumSwipeThresholdDistance {
            swipeMade = true
        }
    }
    
    /// Process the end of the touches. Determind if the gesture is recognized or not! Raise the dead
    ///
    /// - Parameters:
    ///   - touches: Set of finger locations
    ///   - event: Event driving us all to the brink
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        if swipeMade {
            state = .recognized
        }
    }
    
    /// Cancel the touches because--Hey! I've got a phone call
    ///
    /// - Parameters:
    ///   - touches: Set of finger locations
    ///   - event: Event of the touching
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        reset()
    }
}
