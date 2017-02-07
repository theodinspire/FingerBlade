//
//  ViewController.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 1/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var check: UILabel!
    
    var timer: Timer?
    var paths: [[CGPoint]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        check.text = ""
        
        let recognizer = UITapSwipeGestureRecognizer(target: self, action: #selector(handleTapSwipe(_:)))
        
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTapTouchesRequired = 1
        recognizer.numberOfSwipeTouchesRequired = 1
        recognizer.minimumSwipeThresholdDistance = 100
        
        view.addGestureRecognizer(recognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleTapSwipe(_ sender: UITapSwipeGestureRecognizer) {
        self.view.backgroundColor = UIColor(hue: 0.425, saturation: 0.68, brightness: 1, alpha: 1)
        check.text = "✔"
        
        let trail = sender.trail
        paths.append(trail)
        drawPath(along: trail)
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.timerFired(timer:)), userInfo: nil, repeats: false)
    }
    
    @objc func timerFired(timer: Timer) {
        self.view.backgroundColor = UIColor.white
        check.text = ""
        //aPath = UIBezierPath()
    }
    
    func drawPath(along trail:[CGPoint]) {
        // TODO: Figure out how to draw a path
    }
    
}

