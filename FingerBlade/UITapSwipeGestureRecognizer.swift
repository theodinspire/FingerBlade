//
//  UITapSwipeGestureRecognizer.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 1/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

import UIKit.UIGestureRecognizerSubclass

class UITapSwipeGestureRecognizer: UIGestureRecognizer {
    //  Things to match the native libraries
    //  Tap requirements
    var numberOfTapsRequired: Int = 1
    var numberOfTapTouchesRequired: Int = 1
    //  Swipe Requirements
    //var direction: UISwipeGestureRecognizerDirection = .down
    var numberOfSwipeTouchesRequired: Int = 1
    
    //  Internal items
    var tapsMade = 0
    var swipeMade = false
    
    var startingPoint: CGPoint = CGPoint()
    
    //  Testing items
    
    override func reset() {
        super.reset()
        tapsMade = 0
        swipeMade = false
        state = .possible
        startingPoint = CGPoint()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        print("Touch began")
        
        if tapsMade == 0 {
            state = .began
            startingPoint = location(in: view)
        }
        
        tapsMade += 1
        
        //  Handle Taps
        if tapsMade <= numberOfTapTouchesRequired {
            if numberOfTouches != numberOfTapTouchesRequired {
                state = .failed
                return
            }
        } else if tapsMade == numberOfTapTouchesRequired + 1 {  //  Swipe
            if numberOfTouches != numberOfSwipeTouchesRequired {
                state = .failed
                return
            }
            startingPoint = location(in: view?.window)
        } else {
            state = .failed
            return
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .failed {
            return
        }
        
        let loc = location(in: view)
        state = .changed
        
        if tapsMade == numberOfTapsRequired + 1 {
            let deltaX = loc.x - startingPoint.x
            let deltaY = loc.y - startingPoint.y
            
            // Setting distance for minimum swipe
            if 200 <= sqrt(deltaX * deltaX + deltaY * deltaY) {
                state = .failed
                return
            } else {
                swipeMade = true
                state = .ended
            }
        } else {
            state = .failed
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        if swipeMade {
            state = .ended
        } else if tapsMade >= numberOfTapsRequired + 1 {
            state = .failed
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        super.reset()
    }
    
    //  IB Inspectables
    //      Taps
    @IBInspectable var taps: Int = 1 {
        didSet {
            self.numberOfTapsRequired = taps
        }
    }
    @IBInspectable var tapTouches: Int = 1 {
        didSet {
            self.numberOfTapTouchesRequired = tapTouches
        }
    }
    //      Swipes
    @IBInspectable var swipeTouches: Int = 1 {
        didSet {
            self.numberOfSwipeTouchesRequired = swipeTouches
        }
    }
}
