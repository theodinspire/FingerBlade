//
//  SampleStore.swift
//  FingerBlade
//
//  Created by Cormack on 2/10/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation
import UIKit

class SampleStore {
    private var trails = [CutLine : [[CGPoint]]]()
    var cutsToMake: Int
    var cutList: [CutLine]
    var iter: IndexingIterator<[CutLine]>
    
    init(cutsToMake numCuts: Int, cutList cuts: [CutLine]) {
        cutsToMake = numCuts
        cutList = cuts
        iter = cutList.makeIterator()
    }
    
    convenience init () {
        self.init(cutsToMake: 10, cutList: //CutLine.all)
            [CutLine.fendManTut, .sotManFal])   //  TODO: Reset this
    }
    
    func put(trail: [CGPoint], into cut: CutLine) {
        if trails.keys.contains(cut) {
            trails[cut]?.append(trail)
        } else {
            trails[cut] = [trail]
        }
    }
    
    func get(from cut: CutLine) -> [[CGPoint]]? {
        return trails[cut]
    }
    
    func next() -> CutLine? {
        return iter.next()
    }
    
    func getVerboseString() -> String {
        var text = ""
        
        for (cut, trailList) in trails {
            text += cut.rawValue + "\n"
            for trail in trailList {
                for (i, point) in trail.enumerated() {
                    text += (i != 0 ? ", " : "") + String(describing: point)
                }
                text += "\n"
            }
            text += "\n"
        }
        
        return text
    }
}
