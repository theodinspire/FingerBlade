//
//  CutViewController.swift
//  FingerBlade
//
//  Created by Cormack on 3/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class CutViewController: UIViewController {
    @IBOutlet weak var countLabel: UILabel!
    
    var cutStore: SampleStore!
    var shuffled = false
    var counter = 1
    var cutsToMake = 3
    var cut: CutLine?
    var cutIterator: IndexingIterator<[CutLine]>?
    
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
        
        view.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if cutStore == nil { cutStore = SampleStore() }
        cutIterator = CutLine.all.makeIterator()
        
        aniGen = AnimationGenerator(withPathGenerator: CutPathGenerator(ofSize: view.bounds.size))
        countLabel.text = String(counter)
        
        setUp(cut: cutIterator?.next())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func setUp(cut: CutLine?) {
        self.cut = cut
        
        CATransaction.begin()
        if aniLayer != nil {
            aniLayer.removeAllAnimations()
            aniLayer.removeFromSuperlayer()
        }
        
        guard cut != nil else {
            //  TODO: set up segue
            CATransaction.commit()
            return
        }
        
        aniLayer = aniGen.tapSwipeAnimation(forCut: cut!)
        view.layer.addSublayer(aniLayer)
        CATransaction.commit()
    }
    
    func cutMade(_ sender: UITapSwipeGestureRecognizer) {
        counter += 1
        
        guard cut != nil else { return }
        cutStore.put(trail: sender.trail, into: cut!)
        
        if counter > cutsToMake {
            counter = 1
            setUp(cut: cutIterator?.next())
        }
        
        countLabel.text = String(counter)
    }
}
