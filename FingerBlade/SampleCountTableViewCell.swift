//
//  SampleCountTableViewCell.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 3/8/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class SampleCountTableViewCell: UITableViewCell {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countStepper: UIStepper!
    
    var delegate: SelectionViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// Performs the stepper value changed action
    ///
    /// - Parameter sender: Stepper object
    @IBAction func stepped(_ sender: UIStepper) {
        let count = Int(sender.value)
        countLabel.text = String(count)
        delegate?.samplesPerCut = count
    }
}
