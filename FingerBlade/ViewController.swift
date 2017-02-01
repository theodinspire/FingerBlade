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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        check.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlerTapSwipe(_ sender: UITapSwipeGestureRecognizer) {
        self.view.backgroundColor = UIColor(hue: 0.425, saturation: 0.68, brightness: 1, alpha: 1)
        check.text = "✔"
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.timerFired(timer:)), userInfo: nil, repeats: false)
    }
    
    @objc func timerFired(timer: Timer) {
        self.view.backgroundColor = UIColor.white
        check.text = ""
    }
    
}

