//
//  CutView.swift
//  FingerBlade
//
//  Created by Cormack on 3/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class CutView: UIView {
    var cut: CutLine = .fendManTut
    
    var minLineWidth: CGFloat = 5 // Cannot be zero
    var maxLineWidth: CGFloat = 15
    
    var targetColor = UIColor.darkGray
    
    var pathGenerator: CutPathGenerator!

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Drawing code
        pathGenerator = CutPathGenerator(ofSize: bounds.size)
        let targetPath = pathGenerator.path(for: cut)
        
        targetColor.set()
        
        //  TODO: Animate path
    }

}
