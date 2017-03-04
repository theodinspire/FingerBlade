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
    var aniGen: AnimationGenerator!
    
    let dotDiameter: CGFloat = 40

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
        
        swipe = UITapSwipeGestureRecognizer(target: self, action: #selector(swiped))
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
        aniGen = AnimationGenerator(withPathGenerator: pathGenerator)
        aniGen.dotSize = dotDiameter
        
        //  DotView Location set up
        buildDotView()
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
    
    //  Tutorial methods
    func buildDotView() {
        let diaHalf = dotDiameter / 2
        let start = pathGenerator.start(for: cut)
        
        if dotView == nil {
            dotView = UIView(frame: CGRect(x: start.x - diaHalf, y: start.y - diaHalf, width: dotDiameter, height: dotDiameter))
        } else {
            dotView.isHidden = false
        }
        
        dotView.addGestureRecognizer(tap)
        dotView.layer.addSublayer(aniGen.tapAnimation())
        
        view.addSubview(dotView)
    }
    
    func tapped(_ sender: UITapGestureRecognizer?) {
        //  Remove gesture
        dotView.removeGestureRecognizer(tap)
        
        //  Animate
        if let sublayers = dotView.layer.sublayers {
            for sub in sublayers { sub.removeAllAnimations() }
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.25, // Pause a little for moment
                       options: [.curveEaseInOut, .beginFromCurrentState],
                       animations: { self.dotView.bounds = CGRect(x: self.dotDiameter * 0.25, y: self.dotDiameter * 0.25, width: self.dotDiameter * 0.5, height: self.dotDiameter * 0.5) },
                       completion: { complete in
                        self.view.addGestureRecognizer(self.swipe)
                        self.view.layer.addSublayer(self.aniGen.swipeAnimation(forCut: self.cut))
                        self.dotView.isHidden = complete
                       })
    }
    
    func swiped(_ sender: UITapSwipeGestureRecognizer) {
        view.removeGestureRecognizer(swipe)
        view.layer.removeAllAnimations()
        view.layer.sublayers?.forEach { sublayer in sublayer.removeFromSuperlayer() }
        buildDotView()
    }

}
