//
//  OptionViewController.swift
//  FingerBlade
//
//  Created by Cormack on 3/8/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

protocol OptionViewController {
    /// Alters behavior based on whether the screen is attached to the main menu or not
    var fromMenu: Bool { get set }
}
