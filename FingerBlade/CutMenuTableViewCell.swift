//
//  CutMenuTableViewCell.swift
//  FingerBlade
//
//  Created by Cormack on 3/8/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class CutMenuTableViewCell: UITableViewCell {
    var cut: CutLine!
    var marked = false {
        didSet {
            delegate?.cutsSelected[cut] = marked
        }
    }
    
    var delegate: SelectionViewController?
    
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    @IBAction func switchHit(_ sender: UISwitch) {
        marked = sender.isOn
    }
}
