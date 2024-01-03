//
//  ZJLineView.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/28.
//

import UIKit

/** 动画
 https://www.cnblogs.com/fshmjl/p/8477756.html
 */

class ZJLineView: UIView {

    override func draw(_ rect: CGRect) {
        
        self.firstDrawStraightLineWithRect(rect)
        self.secondDrawStraightLineWithRect(rect)
        self.drawImaginaryLineWithRect(rect)
    
    }
    
    func firstDrawStraightLineWithRect(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(3)
        context?.setStrokeColor(UIColor.orange.cgColor)
        let points = [CGPoint(x: 0, y: 10), CGPoint(x: rect.size.width, y: 10)]
        context?.addLines(between: points)
        context?.strokePath()
        
    }
    
    func secondDrawStraightLineWithRect(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setFillColor(UIColor.yellow.cgColor)
        context?.move(to: CGPoint(x: 10, y: 30))
        context?.addLine(to: CGPoint(x: rect.size.width - 20, y: 30))
        context?.strokePath()
        
    }
    
    func drawImaginaryLineWithRect(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2)
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineDash(phase: 0, lengths: [5, 2])
        context?.move(to: CGPoint(x: 0, y: 50))
        context?.addLine(to: CGPoint(x: rect.size.width, y: 50))
        context?.strokePath()
        
    }

}
