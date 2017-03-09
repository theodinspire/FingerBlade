//
//  SampleStore.swift
//  FingerBlade
//
//  Created by Cormack on 2/10/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation
import UIKit

/// An object for storing the gesture sample data as well as organize their collection
class SampleStore {
    private var trails = [CutLine : [[CGPoint]]]()
    var cutsToMake: Int
    var current: CutLine?
    var cutList: [CutLine]
    var iter: IndexingIterator<[CutLine]>
    
    
    /// First cut of the sequence for the store
    var first: CutLine? {
        get {
            return cutList.first
        }
    }
    
    /// Consructor
    ///
    /// - Parameters:
    ///   - numCuts: Number of gestures to collect for each CutLine
    ///   - cuts: The CutLine guestures collected by the object
    init(cutsToMake numCuts: Int, cutList cuts: [CutLine]) {
        cutsToMake = numCuts
        cutList = cuts
        iter = cutList.makeIterator()
    }
    
    /// Default constructor, using every CutLine with 10 lines each
    convenience init () {
        self.init(cutsToMake: 10, cutList: CutLine.all)
    }
    
    /// Add a sample
    ///
    /// - Parameters:
    ///   - trail: Sample to be added
    ///   - cut: CutLine described by the sample
    func put(trail: [CGPoint], into cut: CutLine) {
        if trails.keys.contains(cut) {
            trails[cut]?.append(trail)
        } else {
            trails[cut] = [trail]
        }
    }
    
    /// Obtain samples
    ///
    /// - Parameter cut: The CutLine which the samples describe
    /// - Returns: Array of gesture trail samples
    func get(from cut: CutLine) -> [[CGPoint]]? { return trails[cut] }
    
    /// Get the next cut of the sequence
    ///
    /// - Returns: Next cut whose samples are to be collected
    func next() -> CutLine? {
        current = iter.next()
        return current
    }
    
    /// Descriptive string of the sample corpus. Organized and labeled by CutLine, each line is a sample consisting of the cartesian coordinates describing the sample
    ///
    /// - Returns: A verbose string
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
