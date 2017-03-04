//
//  TutorialViewController.swift
//  FingerBlade
//
//  Created by Cormack on 3/3/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    let lefty = UserDefaults.standard.string(forKey: "Hand") == "Left"
    let cut: CutLine = .fendManTut
    var pathGenerator: CutPathGenerator!
    
    var genPath: UIBezierPath?
    
    let dotDiameter: CGFloat = 40
    let smallDotRatio: CGFloat = 0.75

    var dotView: UIView!
    var tap: UITapGestureRecognizer!
    var swipe: UITapSwipeGestureRecognizer!
    var tapSwipe: UITapSwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        
        swipe = UITapSwipeGestureRecognizer(target: self, action: nil)
        swipe.numberOfTapsRequired = 0
        swipe.numberOfTapTouchesRequired = 1
        swipe.numberOfSwipeTouchesRequired = 1
        
        tapSwipe = UITapSwipeGestureRecognizer(target: self, action: nil)
        tapSwipe.numberOfTapsRequired = 1
        tapSwipe.numberOfTapTouchesRequired = 1
        tapSwipe.numberOfSwipeTouchesRequired = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //  Path generation
        pathGenerator = CutPathGenerator(ofSize: view!.bounds.size)
        genPath = pathGenerator.path(for: cut)
        
        //  Animation set up
        let aniGen = AnimationGenerator(withPathGenerator: pathGenerator)
        aniGen.dotSize = dotDiameter
        
        //  DotView Location set up
        let diaHalf = dotDiameter / 2
        let start = pathGenerator.start(for: cut)
        
        dotView = UIView(frame: CGRect(x: start.x - diaHalf, y: start.y - diaHalf, width: dotDiameter, height: dotDiameter))
        dotView.addGestureRecognizer(tap)
        dotView.layer.addSublayer(aniGen.tapAnimation())
        
        view.addSubview(dotView)
    }
    
    func tapped(_ sender: UITapGestureRecognizer?) {
        //  Remove gesture
        dotView.removeGestureRecognizer(tap)
        
        //  Set up stroke
        //  Draw the exemplar stroke
        let bezierPath = genPath
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath?.cgPath
        view.layer.addSublayer(shapeLayer)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineWidth = 20
        
        let strokeEndAnimation: CAAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 2
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let group = CAAnimationGroup()
            group.duration = 3
            group.repeatCount = .greatestFiniteMagnitude
            group.animations = [animation]
            
            return group
        }()
        
        let strokeStartAnimation: CAAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeStart")
            animation.beginTime = 1
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 2
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let group = CAAnimationGroup()
            group.duration = 3
            group.repeatCount = .greatestFiniteMagnitude
            group.animations = [animation]
            
            return group
        }()
        
        
        
        //  Animate
        dotView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseInOut, .beginFromCurrentState],
                       animations: { self.dotView.bounds = CGRect(x: self.dotDiameter * 0.25, y: self.dotDiameter * 0.25, width: self.dotDiameter * 0.5, height: self.dotDiameter * 0.5) },
                       completion: { complete in
                        self.dotView.isHidden = complete })
        
        shapeLayer.add(strokeEndAnimation, forKey: "strokeEnd")
        shapeLayer.add(strokeStartAnimation, forKey: "strokeStart")
        
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

}
