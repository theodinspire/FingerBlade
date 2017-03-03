//
//  CutLine.swift
//  FingerBlade
//
//  Created by Cormack on 2/10/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

enum CutLine: String {
    case fendManTut = "Fendente Mandritto Tutto"
    case fendManMez = "Fendente Mandritto Mezzo"
    case fendRivTut = "Fendente Riverso Tutto"
    case fendRivMez = "Fendente Riverso Mezzo"
    case mezMan     = "Mezzano Mandritto"
    case mezRiv     = "Mezzano Riverso"
    case sotManTut  = "Sottano Mandritto Tutto"
    case sotManMez  = "Sottano Mandritto Mezzo"
    case sotManFal  = "Sottano Mandritto Falso"
    case sotRivTut  = "Sottano Riverso Tutto"
    case sotRivMez  = "Sottano Riverso Mezzo"
    case sotRivFal  = "Sottano Riverso Falso"
    case punSot     = "Punta Sottomana"
    case punSop     = "Punta Sopromana"
    case punCav     = "Punta Sottomana con Cavazione"
    
    static var all: [CutLine] {
        return [.fendManTut, .fendManMez, .fendRivTut,
            .fendRivMez, .mezMan, .mezRiv, .sotManTut,
            .sotManMez, .sotManFal, .sotRivTut, .sotRivMez,
            .sotRivFal, .punSot, .punSop, .punCav]
    }
}
