//
//  Emitter.swift
//  iLashCustomer
//
//  Created by Dominic Saragaglia on 12/11/17.
//  Copyright © 2017 iLash inc. All rights reserved.
//

import UIKit
class Emitter {
    static func get(with image: UIImage) -> CAEmitterLayer{
        let emitter = CAEmitterLayer()
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterCells = generateEmitterCells(with: image)
        
        return emitter
    }
    static func generateEmitterCells(with image: UIImage) -> [CAEmitterCell]{
        var cells = [CAEmitterCell]()
        
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = 2
        cell.lifetime = 60
        cell.velocity = CGFloat(35)
        cell.emissionLongitude = (180 * (.pi / 180))
        cell.emissionRange = (45 * (.pi / 180))
        cell.scale = 0.1
        cell.scaleRange = 0.04
        cell.spin = 1.25
        cell.spinRange = 0.35
        
        cells.append(cell)
        return cells
    }
}
