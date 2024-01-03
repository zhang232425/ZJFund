//
//  CAShapeLayerVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/3.
//

import UIKit

class CAShapeLayerVC: BaseVC {
    
    private lazy var animationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

}

private extension CAShapeLayerVC {
    
    func config() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "测试", style: .plain, target: self, action: #selector(testClick))
        
        shape()
        
    }
    
    @objc func testClick() {
        
        // @[@"1",@"4",@"3",@"2",@"8",@"6",@"2",@"8",@"5",@"7",@"4",@"6"]]
        animationView.setItemValues([1, 4, 3, 2, 8, 6, 2, 8, 5, 7, 4, 6])
        
    }
    
}

private extension CAShapeLayerVC {
    
    func shape() {
        
//        ShapeView().add(to: view).snp.makeConstraints {
//            $0.left.top.right.equalToSuperview()
//            $0.bottom.equalToSuperview().inset(100)
//        }
        
//        RoundView().then {
//            $0.backgroundColor = .orange
//        }.add(to: view).snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.size.equalTo(200)
//        }
        
        animationView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}

/***--------------------- 备注 ------------------- ***/

/**
 CAShapeLayer：属于CoreAnimation框架，通过GPU渲染图形，不耗费性能
 drawRect：属于Core Graphics框架，大量占用CUP，耗费性能
 */

/**
 CAShapeLayer继承自CALayer，具有CALayer的所有特征，但是CAShapeLayer要搭配UIBezierPath配合使用才有意义
 将UIBezierPath对象转化为CGPathRef对象，赋值给CAShapeLayer的path属性，即可画出各种图形
 */

/**
 path : CGPathRef对象，图像形状的路径
 fillColor：CGColorRef对象，图像填充颜色，默认黑色
 strokeColor：边线的颜色
 strokeStart,strokeEnd：CGFloat类型，表示画边线的起点和终点，范围是[0,1]。
 lineWidth：边线的宽度
 miterLimit：描边时使用的斜接限制。默认为10。
 lineCap：线条终点的样式
 lineJoin：线条拐点的样式
 lineDashPhase：边线的起始位置，表现是一段空白
 lineDashPattern：这是一个数组，表示设置边线的样式，默认是实线，数组中的数值依次表示虚线中，单个线段长度，一段空白长度，比如：@[2,3,4,5]表示：长度为2的线，后面长度为3的空白，后面长度为4的线，，长度为5的空白，以此类推，不断循环。
 */

fileprivate class ShapeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawArc(bounds)
    }
    
    func drawLine(_ rect: CGRect) {
        
        // 创建路径对象
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 100, y: 100))
        path.addLine(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 250, y: 150))
        
        // 设置路径画布
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        layer.position = CGPoint(x: rect.midX, y: rect.midY)
        layer.lineWidth = 3.0
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = nil
        layer.path = path.cgPath
        
        self.layer.addSublayer(layer)
        
    }
    
    func drawPolygon(_ rect: CGRect) {
    
        // 创建路径对象
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50, y: 100))
        path.addLine(to: CGPoint(x: 150, y: 50))
        path.addLine(to: CGPoint(x: 250, y: 100))
        path.addLine(to: CGPoint(x: 250, y: 200))
        path.addLine(to: CGPoint(x: 100, y: 200))
        path.close()
        
        // 设置画布
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        layer.position = CGPoint(x: rect.midX, y: rect.midY)
        layer.lineWidth = 3.0
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.yellow.cgColor
        layer.path = path.cgPath
        
        self.layer.addSublayer(layer)
        
    }
    
    func drawArc(_ rect: CGRect) {
        
        // 创建路径
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 80, startAngle: 1.25 * .pi, endAngle: 1.75 * .pi, clockwise: true)
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.close()
        
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        layer.position = CGPoint(x: rect.midX, y: rect.midY)
        layer.lineWidth = 3
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.yellow.cgColor
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        layer.path = path.cgPath
        
        self.layer.addSublayer(layer)
        
    }
    
    func drawRound(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        
        let layer = CAShapeLayer()
        layer.frame = rect
        layer.path = path.cgPath
        
        self.layer.addSublayer(layer)
        self.layer.mask = layer
        
    }
    
}

fileprivate class RoundView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.darwRound(bounds)
    }
    
    func darwRound(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        
        let layer = CAShapeLayer()
        layer.frame = rect
        layer.path = path.cgPath
        
        self.layer.addSublayer(layer)
        self.layer.mask = layer
        
    }
    
}

fileprivate class AnimationView: UIView {
    
    func setItemValues(_ items: [Int]) {
        
        let path = UIBezierPath()
        let margin = 50, w = 30, h = 20
        for (index, value) in items.enumerated() {
            let point = CGPoint(x: margin + index * w, y: h * value + 100)
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        let layer = CAShapeLayer()
        layer.lineWidth = 3.0
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.path = path.cgPath
        
        self.layer.addSublayer(layer)
        
        let anmi = CABasicAnimation()
        anmi.keyPath = "strokeEnd"
        anmi.fromValue = NSNumber(value: 0)
        anmi.toValue = NSNumber(value: 1)
        anmi.duration = 5
        anmi.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anmi.autoreverses = false
        
        layer.add(anmi, forKey: "stroke")
        
    }
    
}
