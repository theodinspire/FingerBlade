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
    
    let lefty = UserDefaults.standard.string(forKey: "Hand") == "Left"
    let cut: CutLine = .fendManTut
    var pathGenerator: CutPathGenerator!
    
    var genPath: UIBezierPath?
    var aniGen: AnimationGenerator!
    var shapeLayer: CAShapeLayer?
    
    let dotDiameter: CGFloat = 40

    var dotView: UIView!
    var tap: UITapGestureRecognizer!
    var swipe: UITapSwipeGestureRecognizer!
    var tapSwipe: UITapSwipeGestureRecognizer!
    
    var tapMade = false
    var swipeMade = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        aniGen = AnimationGenerator(withPathGenerator: pathGenerator)
        aniGen.dotSize = dotDiameter
        
        let diaHalf = dotDiameter / 2
        let start = pathGenerator.start(for: cut)
        
        dotView = UIView(frame: CGRect(x: start.x - diaHalf, y: start.y - diaHalf, width: dotDiameter, height: dotDiameter))
        dotView.backgroundColor = UIColor.clear
        
        //dotView.backgroundColor = UIColor.blue
        
        dotView.addGestureRecognizer(tap)
        
        shapeLayer = aniGen.tapAnimation(forCut: cut)
        view.layer.addSublayer(shapeLayer!)
        
        view.addSubview(dotView)
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
    
    //  Tutorial Methods
    func tapped(_ sender: UITapGestureRecognizer?) {
        CATransaction.begin()
        
        dotView.removeGestureRecognizer(tap)
        dotView.removeFromSuperview()
        
        shapeLayer?.removeAllAnimations()
        shapeLayer?.removeFromSuperlayer()
        
        shapeLayer = aniGen.swipeAnimation(forCut: cut)
        view.layer.addSublayer(shapeLayer!)
        
        view.addGestureRecognizer(swipe)
        
        CATransaction.commit()
    }
    
    func swiped(_ sender: UITapSwipeGestureRecognizer) {
        CATransaction.begin()
        
        view.removeGestureRecognizer(swipe)
        
        shapeLayer?.removeAllAnimations()
        shapeLayer?.removeFromSuperlayer()
        
        shapeLayer = aniGen.tapSwipeAnimation(forCut: cut)
        view.layer.addSublayer(shapeLayer!)
        
        view.addGestureRecognizer(tapSwipe)
        
        CATransaction.commit()
    }
    
    func  tapSwiped(_ sender: UITapSwipeGestureRecognizer) {
        view.removeGestureRecognizer(tapSwipe)
        
        CATransaction.begin()
        for layer in view.layer.sublayers! {
            if let shapeLayer = layer as? CAShapeLayer {
                shapeLayer.removeAllAnimations()
                shapeLayer.path = UIBezierPath().cgPath
                shapeLayer.removeFromSuperlayer()
            }
        }
        CATransaction.commit()
        
        contButton.isHidden = false
    }

}
