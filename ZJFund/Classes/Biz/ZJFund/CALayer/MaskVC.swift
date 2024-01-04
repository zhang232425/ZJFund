//
//  MaskVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/4.
//

import UIKit

/**
 问题一：什么是mask？
 mask是layer的一个属性，也是UILayer类型，具有其他图层一样的绘制和布局属性
 问题二：mask的作用?
 mask的作用就是让父图层与mask重叠的部分区域可见，就是说mask图层实心的部分将会被保留下来，mask与父视图不重合的部分则会被抛弃
 mask 可以配合CAGradientLayer、CAShapeLayer 使用。可以实现蒙层透明度、显示不同形状图层、图案镂空、文字变色等等功能。
 */

class MaskVC: BaseVC {
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .red
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

}

private extension MaskVC {
    
    func setupViews() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mask", style: .plain, target: self, action: #selector(maskClick))
        
        containerView.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.size.equalTo(300)
        }
    
//        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
//        let path = UIBezierPath(arcCenter: CGPoint(x: 200, y: 200), radius: 100, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
//        let layer = CAShapeLayer()
//        layer.path = path.cgPath
        
        let layer = CALayer()
        layer.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        layer.backgroundColor = UIColor.orange.cgColor
    
        containerView.layer.mask = layer
        
    }
    
    @objc func maskClick() {
        
        
        
    }
    
}

fileprivate class MaskTestView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawMask(bounds)
    }
    
    func drawMask(_ rect: CGRect) {
    
    }
    
}
