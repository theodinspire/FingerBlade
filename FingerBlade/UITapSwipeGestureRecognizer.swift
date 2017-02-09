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
    var minimumSwipeThresholdDistance: CGFloat = 100
    
    //  Internal items
    var tapsMade = 0
    var swipeMade = false
    
    var timer: Timer?
    
    var startingPoint: CGPoint = CGPoint()
    var trail: [CGPoint] = []
    
    //  Testing items
    
    override func reset() {
        super.reset()
        tapsMade = 0
        swipeMade = false
        state = .possible
        timer = nil
        
        startingPoint = CGPoint()
        //print(startingPoint)
        
        if !trail.isEmpty {
            trail.removeAll(keepingCapacity: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        print("Touch began")
        
        stopTimer()
        
        tapsMade += 1
        
        //  Handle Taps
        if (tapsMade <= numberOfTapsRequired && numberOfTouches != numberOfTapTouchesRequired) ||
            (tapsMade == numberOfTapsRequired + 1 && numberOfTouches != numberOfSwipeTouchesRequired) ||
            tapsMade > numberOfTapsRequired + 1 {
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        //  Don't do anything if the state is currently failed
        if state == .failed {
            return
        }
        
        //  Moves shouldn't be happening on taps
        if tapsMade != numberOfTapsRequired + 1 {
            state = .failed
            return
        }   //  Check for correct number of touches already made
        
        let loc = location(in: view?.window)
        trail.append(loc)
        //print(loc)
        
        let deltaX = loc.x - /*trail.first!.x*/ startingPoint.x
        let deltaY = loc.y - /*trail.first!.y*/ startingPoint.y
        
        if !swipeMade && sqrt(deltaX * deltaX + deltaY * deltaY) >= minimumSwipeThresholdDistance {
            swipeMade = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        //if let last = trail.last { print(last) }
        if swipeMade {
            state = .recognized
        } else {
            startTimer()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        reset()
    }
    
    //  Timer Functions
    func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fireTimer(_:)), userInfo: nil, repeats: false)
    }
    
    func stopTimer() {
        if let tmr = timer {
            if tmr.isValid { tmr.invalidate() }
        }
    }
    
    @objc func fireTimer(_ timer: Timer) {
        state = .failed
    }
    
    
    //  IB Inspectables
    //      Taps
    @IBInspectable var taps: Int = 1 {
        didSet {
            numberOfTapsRequired = taps
        }
    }
    @IBInspectable var tapTouches: Int = 1 {
        didSet {
            numberOfTapTouchesRequired = tapTouches
        }
    }
    //      Swipes
    @IBInspectable var swipeTouches: Int = 1 {
        didSet {
            numberOfSwipeTouchesRequired = swipeTouches
        }
    }
    @IBInspectable var minSwipeDistance: CGFloat = 100 {
        didSet {
            minimumSwipeThresholdDistance = minSwipeDistance
        }
    }
}
