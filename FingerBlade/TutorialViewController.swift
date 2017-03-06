//
//  TutorialViewController.swift
//  FingerBlade
//
//  Created by Cormack on 3/3/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak var contButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    let lefty = UserDefaults.standard.string(forKey: "Hand") == "Left"
    let cut: CutLine = .fendManTut
    
    var pathGenerator: CutPathGenerator!
    
    var aniGen: AnimationGenerator!
    var shapeLayer: CAShapeLayer?
    var wordPath: UIBezierPath?
    var wordPause: UIBezierPath?
    var word: UILabel?

    var dotView: UIView!
    var tap: UITapGestureRecognizer!
    var swipe: UITapSwipeGestureRecognizer!
    var tapSwipe: UITapSwipeGestureRecognizer!
    
    let cutStore = SampleStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messageView.alpha = 0
        messageView.layer.zPosition = 1
        contButton.layer.zPosition = 2
        
        tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        
        swipe = UITapSwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipe.numberOfTapsRequired = 0
        swipe.numberOfTapTouchesRequired = 1
        swipe.numberOfSwipeTouchesRequired = 1
        
        tapSwipe = UITapSwipeGestureRecognizer(target: self, action: #selector(tapSwiped))
        tapSwipe.numberOfTapsRequired = 1
        tapSwipe.numberOfTapTouchesRequired = 1
        tapSwipe.numberOfSwipeTouchesRequired = 1
        
        contButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //  Path generation
        pathGenerator = CutPathGenerator(ofSize: view!.bounds.size)
        
        //  Animation set up
        //Touch
        aniGen = AnimationGenerator(withPathGenerator: pathGenerator)
        let dotDiameter = aniGen.dotSize
        shapeLayer = aniGen.tapAnimation(forCut: cut)
        //Words
        word = UILabel()
        word?.text = "Tap"
        word?.sizeToFit()
        word?.center = aniGen.swipeWordStartPoint(forCut: cut)
        
        //  Set up view for the touch area
        let diaHalf = dotDiameter / 2
        let start = pathGenerator.start(for: cut)
        dotView = UIView(frame: CGRect(x: start.x - diaHalf, y: start.y - diaHalf, width: dotDiameter, height: dotDiameter))
        dotView.backgroundColor = UIColor.clear
        dotView.addGestureRecognizer(tap)

        //  Add to view
        view.layer.addSublayer(shapeLayer!)
        view.addSubview(dotView)
        view.addSubview(word!)
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
        if let nextView = segue.destination as? CutViewController {
            nextView.cutStore = cutStore
            nextView.counter = 1
            nextView.cutList = CutLine.all
        }
     }
    
    //  Tutorial Methods
    func tapped(_ sender: UITapGestureRecognizer?) {
        CATransaction.begin()
        
        //  Remove all previous animations
        dotView.removeGestureRecognizer(tap)
        dotView.removeFromSuperview()
        
        word?.layer.removeAllAnimations()
        word?.removeFromSuperview()
        
        shapeLayer?.removeAllAnimations()
        shapeLayer?.removeFromSuperlayer()
        
        // Establish new animations
        word = UILabel()
        word?.text = "Swipe"
        word?.sizeToFit()
        word?.center = aniGen.swipeWordRestPoint(forCut: cut)
        word?.layer.add(aniGen.wordSwipeAnimation(forCut: cut), forKey: "position")
        
        shapeLayer = aniGen.swipeAnimation(forCut: cut)
        view.layer.addSublayer(shapeLayer!)
        view.addSubview(word!)
        
        view.addGestureRecognizer(swipe)
        
        CATransaction.commit()
    }
    
    func swiped(_ sender: UITapSwipeGestureRecognizer) {
        CATransaction.begin()
        
        //  Remove all previous animations
        view.removeGestureRecognizer(swipe)
        
        word?.layer.removeAllAnimations()
        word?.removeFromSuperview()
        
        shapeLayer?.removeAllAnimations()
        shapeLayer?.removeFromSuperlayer()
        
        //  Establish new animations
        word = UILabel()
        word?.numberOfLines = 0
        word?.textAlignment = .center
        word?.text = "Tap and\nSwipe"
        word?.sizeToFit()
        word?.center = aniGen.swipeWordRestPoint(forCut: cut)
        word?.layer.add(aniGen.wordSwipeAnimation(forCut: cut, long: true), forKey: "position")
        
        shapeLayer = aniGen.tapSwipeAnimation(forCut: cut)
        view.layer.addSublayer(shapeLayer!)
        view.addSubview(word!)
        
        view.addGestureRecognizer(tapSwipe)
        
        CATransaction.commit()
    }
    
    func  tapSwiped(_ sender: UITapSwipeGestureRecognizer) {
        view.removeGestureRecognizer(tapSwipe)
        
        CATransaction.begin()
        shapeLayer?.removeAllAnimations()
        shapeLayer?.removeFromSuperlayer()
        word?.layer.removeAllAnimations()
        word?.removeFromSuperview()
        CATransaction.commit()
        
        //  Message animations
        contButton.alpha = 0
        contButton.isHidden = false
        
        messageLabel.text = "You got it!"
        
        let animateIn = { self.messageView.alpha = 1; self.contButton.alpha = 1 }
        
        let options: UIViewAnimationOptions = [.curveEaseInOut, .beginFromCurrentState]
        
        UIView.animate(withDuration: 0.5, delay: 0, options: options, animations: animateIn, completion: nil)
        
        //  Prepare
        cutStore.put(trail: sender.trail, into: cut)
    }

}
