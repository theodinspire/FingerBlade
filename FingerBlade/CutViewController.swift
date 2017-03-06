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
    @IBOutlet weak var cutLabel: UILabel!
    @IBOutlet weak var countView: UIView!
    
    var cutStore: SampleStore!
    var shuffled = false
    var counter = 1
    var cutsToMake = 10
    var cut: CutLine?
    var cutIterator: IndexingIterator<[CutLine]>?
    
    var cutList: [CutLine]?
    
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
        //countLabel.alpha = 0
        
        view.addGestureRecognizer(recognizer)
        
        cutIterator = cutList?.makeIterator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if cutStore == nil { cutStore = SampleStore() }
        cutIterator = //CutLine.all.makeIterator()
            [CutLine.fendManTut, .punSot].makeIterator()
        aniGen = AnimationGenerator(withPathGenerator: CutPathGenerator(ofSize: view.bounds.size))
        countLabel.text = String(counter)
        //countLabel.font = countLabel.font.withSize(60)
        
        //countLabel.layer.zPosition = 1
        countView.layer.zPosition = 1
        countLabel.layer.zPosition = 1
        
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
        cutLabel.text = cut?.rawValue ?? "Done!"
        
        CATransaction.begin()
        if aniLayer != nil {
            aniLayer.removeAllAnimations()
            aniLayer.removeFromSuperlayer()
        }
        
        guard cut != nil else {
            //  TODO: set up segue
            CATransaction.commit()
            let handler = DataFileHandler()
            handler.writeSample(store: cutStore)
            handler.send()
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
        
        if counter >= cutsToMake {
            counter = 0
            setUp(cut: cutIterator?.next())
        }
        
        countLabel.text = counter == 0 ? "✔︎" : String(counter)
        
        let animateIn = { self.countView.alpha = 1 }
        let animateOut = { self.countView.alpha = 0 }
        
        let options: UIViewAnimationOptions = [.curveEaseInOut, .beginFromCurrentState]
        
        let completion = { (_: Bool) -> Void in UIView.animate(withDuration: 0.5, delay: 0, options: options, animations: animateOut, completion: nil) }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: options, animations: animateIn, completion: completion)
    }
}
