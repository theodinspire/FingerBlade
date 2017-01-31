//
//  ViewController.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 1/27/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tapCount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlerTapSwipe(_ sender: UITapSwipeGestureRecognizer) {
        tapCount.text = String(sender.tapsMade)
        
        switch sender.state {
        case .began:
            self.view.backgroundColor = UIColor.darkGray
        case .ended:
            self.view.backgroundColor = UIColor.gray
        default:
            self.view.backgroundColor = UIColor.white
        }
    }
    
}

