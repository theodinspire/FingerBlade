//
//  CutLine.swift
//  FingerBlade
//
//  Created by Cormack on 2/10/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

enum CutLine: String {
    case fendManTut = "Full Cut"
    case fendManMez = "Half Cut"
    case fendRivTut = "Full Backhand Cut"
    case fendRivMez = "Half Backhand Cut"
    case mezMan     = "Lateral Cut"
    case mezRiv     = "Lateral Backhand Cut"
    case sotManTut  = "Full True-Edge Rising Cut"
    case sotManMez  = "Half True-Edge Rising Cut"
    case sotManFal  = "False-Edge Rising Cut"
    case sotRivTut  = "Full True-Edge Rising Backhand Cut"
    case sotRivMez  = "Half True-Edge Rising Backhand Cut"
    case sotRivFal  = "False-Edge Rising Backhand Cut"
    case punSot     = "Thrust"
    case punSop     = "Overhand Thrust"
    case punCav     = "Thrust with Disengagement"
    
    /// A list of all the available cuts. Must be updated manually if any are added
    static var all: [CutLine] {
        return [.fendManTut, .fendRivTut, .fendManMez,
            .fendRivMez, .mezMan, .mezRiv, .sotManTut,
            .sotRivTut, .sotManMez, .sotRivMez, .sotManFal,
            .sotRivFal, .punSot, .punSop, .punCav]
    }
}
