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
    let cut: CutLine = //.fendManTut
        .punCav
    
    var cutPath: CutDrawPath?
    var pathGenerator: CutPathGenerator!
    
    var genPath: UIBezierPath?
    
    let dotDiameter: CGFloat = 40
    let smallDotRatio: CGFloat = 0.75

    var dotView: DotView!
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
        let diaHalf = dotDiameter / 2
        
        cutPath = CutDrawPath.getExemplar(cut: cut, bounds: view.bounds)
        
        pathGenerator = CutPathGenerator(ofSize: view!.bounds.size)
        genPath = pathGenerator.path(for: cut)
        
        let start = //cutPath?.start ?? CGPoint(x: 100, y: 100)
            pathGenerator.start(for: cut)
        
        dotView = DotView(frame: CGRect(x: start.x - diaHalf, y: start.y - diaHalf, width: dotDiameter, height: dotDiameter))
        dotView.addGestureRecognizer(tap)
        view.addSubview(dotView)
        dotView.bounds = CGRect(x: dotDiameter * 0.125, y: dotDiameter * 0.125, width: dotDiameter * 0.75, height: dotDiameter * 0.75)
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [.beginFromCurrentState, .autoreverse, .repeat, .curveEaseInOut, .allowUserInteraction],
                       animations: { self.dotView.bounds = CGRect(x: 0, y: 0, width: self.dotDiameter, height: self.dotDiameter) },
                       completion: nil)
    }
    
    func tapped(_ sender: UITapGestureRecognizer?) {
        dotView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseInOut, .beginFromCurrentState],
                       animations: { self.dotView.bounds = CGRect(x: self.dotDiameter * 0.5, y: self.dotDiameter * 0.5, width: 0, height: 0) },
                       completion: { complete in self.dotView.isHidden = complete })
        dotView.removeGestureRecognizer(tap)
        
        //  Draw the exemplar stroke
        let bezierPath = //cutPath!.bezierPath
            genPath
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath?.cgPath
        view.layer.addSublayer(shapeLayer)
        
        //shapeLayer.strokeStart = 0
        //shapeLayer.strokeEnd = 0
        
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
