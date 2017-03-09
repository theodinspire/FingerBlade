//
//  CutPath.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 3/3/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class CutPathGenerator {
    let size: CGSize
    let lefty: Bool
    
    init(ofSize size: CGSize) {
        self.size = size
        lefty = UserDefaults.standard.string(forKey: HAND) == "Left"
    }
    
    //  Constant points
    //Corners
    private static let topFore = CGPoint(x: 0.80, y: 0.20)
    private static let bottomFore = CGPoint(x: 0.80, y: 0.80)
    private static let topBack = mirror(point: topFore)
    private static let bottomBack = mirror(point: bottomFore)
    //Thrust startings
    private static let top = CGPoint(x: 0.50, y: 0.20)
    private static let bottom = CGPoint(x: 0.50, y: 0.80)
    //Center diamond
    private static let centerUp = CGPoint(x: 0.50, y: 0.40)
    private static let centerFore = CGPoint(x: 0.60, y: 0.50)
    private static let centerDown = CGPoint(x: 0.50, y: 0.60)
    private static let centerBack = mirror(point: centerFore)
    //Sides
    private static let foreUp = CGPoint(x: 0.80, y: 0.40)
    private static let foreMid = CGPoint(x: 0.80, y: 0.50)
    private static let backUp = mirror(point: foreUp)
    private static let backMid = mirror(point: foreMid)
    //Cavazione turns
    private static let cavazione = CGPoint(x: 0.70, y: 0.50)
    private static let cavUp = CGPoint(x: cavazione.x, y: 0.60)
    private static let cavDown = CGPoint(x: cavazione.x, y: 0.40)
    
    func path(`for` cut: CutLine) -> UIBezierPath {
        let path = UIBezierPath()
        
        let start = self.start(for: cut)
        let end = self.end(for: cut)
        
        path.move(to: start)
        
        switch cut {
        case .fendManTut, .fendManMez, .fendRivTut, .fendRivMez, .mezMan, .mezRiv, .sotRivMez, .sotRivFal, .punSot, .punSop:
            path.addLine(to: end)
        case .sotManTut:
            path.addQuadCurve(to: end, controlPoint: handed(CutPathGenerator.bottomBack) * size)
        case .sotManMez, .sotRivTut:
            path.addQuadCurve(to: end, controlPoint: CutPathGenerator.bottom * size)
        case .sotManFal:
            path.addQuadCurve(to: end, controlPoint: handed(CutPathGenerator.foreUp) * size)
        case.punCav:
            let cav = handed(CutPathGenerator.cavazione)
            path.addCurve(to: cav * size,
                          controlPoint1: mirror(point: cav) * size,
                          controlPoint2: handed(CutPathGenerator.cavDown) * size)
            path.addCurve(to: end,
                          controlPoint1: handed(CutPathGenerator.cavUp) * size,
                          controlPoint2: mirror(point: cav) * size)
            //default:
            //path.addLine(to: end)
        }
        
        return path
    }
    
    func start(`for` cut: CutLine) -> CGPoint {
        let point: CGPoint
        
        switch cut {
        case .fendManTut, .fendManMez:
            point = handed(CutPathGenerator.topFore)
        case .fendRivTut, .fendRivMez:
            point = handed(CutPathGenerator.topBack)
        case .mezMan:
            point = handed(CutPathGenerator.foreUp)
        case .mezRiv:
            point = handed(CutPathGenerator.backUp)
        case .sotManTut, .sotManMez, .sotManFal:
            point = handed(CutPathGenerator.bottomFore)
        case .sotRivTut, .sotRivMez, .sotRivFal:
            point = handed(CutPathGenerator.bottomBack)
        case .punSot, .punCav:
            point = CutPathGenerator.bottom
        case .punSop:
            point = CutPathGenerator.top
            //default:
            //point = CGPoint(x: 0.5, y: 0.5)
        }
        
        return point * size
    }
    
    func end(`for` cut: CutLine) -> CGPoint {
        let point: CGPoint
        
        switch cut {
        case .fendManTut:
            point = handed(CutPathGenerator.bottomBack)
        case .fendManMez, .sotManMez:
            point = handed(CutPathGenerator.centerBack)
        case .fendRivTut:
            point = handed(CutPathGenerator.bottomFore)
        case .fendRivMez, .sotRivMez:
            point = handed(CutPathGenerator.centerFore)
        case .mezMan:
            point = handed(CutPathGenerator.backMid)
        case .mezRiv:
            point = handed(CutPathGenerator.foreMid)
        case .sotManTut, .sotManFal:
            point = handed(CutPathGenerator.topBack)
        case .sotRivTut, .sotRivFal:
            point = handed(CutPathGenerator.topFore)
        case .punSot:
            point = CutPathGenerator.centerUp
        case .punSop:
            point = CutPathGenerator.centerDown
        case .punCav:
            point = CutPathGenerator.top
            //default:
            //point = CGPoint(x: 0.5, y: 0.5)
        }
        
        return point * size
    }
    
    private func handed(_ point: CGPoint) -> CGPoint {
        return lefty ? mirror(point: point) : point
    }
}

extension CGPoint {
    static func *(_ point: CGPoint, _ scale: CGSize) -> CGPoint {
        return CGPoint(x: point.x * scale.width, y: point.y * scale.height)
    }
}
