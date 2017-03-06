//
//  dotView.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 3/3/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class DotView: UIView {
    var color = UIColor.darkGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let ellipse = UIBezierPath(ovalIn: rect)
        color.set()
        ellipse.fill()
    }

}
