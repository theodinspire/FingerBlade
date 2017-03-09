//
//  CutViewController.swift
//  FingerBlade
//
//  Created by Cormack on 3/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class CutViewController: UIViewController, OptionViewController {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var cutLabel: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    var cutStore: SampleStore!
    var counter = 0
    var cut: CutLine?
    
    var fromMenu = false
    
    var aniGen: AnimationGenerator!
    var aniLayer: CAShapeLayer!
    
    var recognizer: UITapSwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recognizer = UITapSwipeGestureRecognizer(target: self, action: #selector(cutMade))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTapTouchesRequired = 1
        recognizer.numberOfSwipeTouchesRequired = 1
        
        countView.alpha = 0
        
        view.addGestureRecognizer(recognizer)
        
        continueButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if cutStore == nil { cutStore = SampleStore() }
        
            //[CutLine.fendManTut, .punSot].makeIterator()
        aniGen = AnimationGenerator(withPathGenerator: CutPathGenerator(ofSize: view.bounds.size))
        countLabel.text = String(counter)
        //countLabel.font = countLabel.font.withSize(60)
        
        //countLabel.layer.zPosition = 1
        countView.layer.zPosition = 1
        countLabel.layer.zPosition = 1
        
        setUp(cut: cutStore.next())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        UserDefaults.standard.set(true, forKey: COMPLETE)
        UserDefaults.standard.removeObject(forKey: STORE)
    }

    /// Starts the animations for the next cut and sets up screen for end of sample. Sends the samples too!
    ///
    /// - Parameter cut: Cut whose path will be shown, or no cut at all
    func setUp(cut: CutLine?) {
        self.cut = cut
        cutLabel.text = cut?.rawValue ?? "Done!"
        
        CATransaction.begin()
        if aniLayer != nil {
            aniLayer.removeAllAnimations()
            aniLayer.removeFromSuperlayer()
        }
        
        guard cut != nil else {
            //  TODO: set up segue
            CATransaction.commit()
            
            view.removeGestureRecognizer(recognizer)
            
            let handler = DataFileHandler()
            handler.writeSample(store: cutStore)
            handler.send()    //  TODO Reestablish
            
            continueButton.isHidden = false
            return
        }
        
        aniLayer = aniGen.tapSwipeAnimation(forCut: cut!)
        view.layer.addSublayer(aniLayer)
        CATransaction.commit()
    }
    
    /// Handler for the tapswipe recognizer. Increments count and adds swipe to sample store
    ///
    /// - Parameter sender: TapSwipe recognizer
    func cutMade(_ sender: UITapSwipeGestureRecognizer) {
        counter += 1
        
        guard cut != nil else { return }
        cutStore.put(trail: sender.trail, into: cut!)
        
        if counter >= cutStore.cutsToMake {
            counter = 0
            setUp(cut: cutStore.next())
        }
        
        countLabel.text = counter == 0 ? "✔︎" : String(counter)
        
        let animateIn = { self.countView.alpha = 1 }
        let animateOut = { self.countView.alpha = 0 }
        
        let options: UIViewAnimationOptions = [.curveEaseInOut, .beginFromCurrentState]
        
        let completion = { (_: Bool) -> Void in UIView.animate(withDuration: 0.5, delay: 0, options: options, animations: animateOut, completion: nil) }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: options, animations: animateIn, completion: completion)
    }
    
    /// Continue or unwind to the Main Menu
    ///
    /// - Parameter sender: Continue button
    @IBAction func continuePressed(_ sender: UIButton) {
        if fromMenu {
            performSegue(withIdentifier: "unwindToMenu", sender: self)
        }
    }
}
