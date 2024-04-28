//
//  HanggeScratchVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/3/28.
//

import UIKit

class HanggeScratchVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

}

private extension HanggeScratchVC {
    
    func setupViews () {
        
        self.navigationItem.title = "刮刮卡"
        
    }
    
}

fileprivate class ScratchMask: UIImageView {
    
    // 代理对象
    weak var delegate: ScratchCardDelegate?
    
    // 线条形状
    var lineType: CGLineCap!
    
    // 线条粗细
    var lineWidth: CGFloat!
    
    // 保留上一次停留的位置
    var lastPoint: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 触摸开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 多点触摸只考虑一点
        guard let touch = touches.first else { return }
        // 保存当前点坐标
        lastPoint = touch.location(in: self)
        // 调用相应的代理方法
        delegate?.scratchBegan(point: lastPoint!)
    }
    
    // 滑动
    /**
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
             //多点触摸只考虑第一点
             guard  let touch = touches.first, let point = lastPoint, let img = image else {
                 return
             }
              
             //获取最新触摸点坐标
             let newPoint = touch.location(in: self)
             //清除两点间的涂层
             eraseMask(fromPoint: point, toPoint: newPoint)
             //保存最新触摸点坐标，供下次使用
             lastPoint = newPoint
              
             //计算刮开面积的百分比
             let progress = getAlphaPixelPercent(img: img)
             //调用相应的代理方法
             delegate?.scratchMoved?(progress: progress)
         }
     */
    
    // 滑动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 多点触摸只考虑一点
        guard let touch = touches.first, let point = lastPoint, let img = image else { return }
        // 获取最新的触摸点坐标
        let newPoint = touch.location(in: self)
        // 清除亮点间的涂层
//        erase
    }
    
    /**
     //清除两点间的涂层
         func eraseMask(fromPoint: CGPoint, toPoint: CGPoint) {
             //根据size大小创建一个基于位图的图形上下文
             UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
              
             //先将图片绘制到上下文中
             image?.draw(in: self.bounds)
              
             //再绘制线条
             let path = CGMutablePath()
             path.move(to: fromPoint)
             path.addLine(to: toPoint)
              
             let context = UIGraphicsGetCurrentContext()!
             context.setShouldAntialias(true)
             context.setLineCap(lineType)
             context.setLineWidth(lineWidth)
             context.setBlendMode(.clear) //混合模式设为清除
             context.addPath(path)
             context.strokePath()
              
             //将二者混合后的图片显示出来
             image = UIGraphicsGetImageFromCurrentImageContext()
             //结束图形上下文
             UIGraphicsEndImageContext()
         }
     */

    func eraseMask(fromPoint: CGPoint, toPoint: CGPoint) {
        // 根据size大小创建一个基于位图的图形上下文
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
    }
    
}


@objc protocol ScratchCardDelegate {
    @objc func scratchBegan(point: CGPoint)
    @objc func scratchMoved(progress: Float)
    @objc func scratchEnded(point: CGPoint)
}
