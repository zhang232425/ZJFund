//
//  CoreGraphicsVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/29.
//

import UIKit


/** https://www.jianshu.com/p/a19c4cbf4d1a
 CGMutablePath 是 Core Graphics 的底层API，而 UIBezierPath 就是对 CGMutablePath 的封装
 */

/**
  绘图的一般步骤
 （1）获取绘图上下文
 （2）创建并设置路径
 （3）将路径添加到上下文
 （4）设置上下文状态（如颜色、宽度、填充色等等）
 （5）绘制路径
 */

class CoreGraphicsVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    deinit {
        print("有无释放")
    }

}

private extension CoreGraphicsVC {
    
    func config() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(testClick))
        
    }
    
    @objc func testClick() {
        
        test()
        
    }
    
    
}

private extension CoreGraphicsVC {
    
    func test() {
        
        ZJBezierView().add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(300)
        }

    }
    
}

// ******************************************** Core Graphics **************************************

fileprivate class LineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        self.drawBezier(rect)
        
    }
    
    /// 绘制实线
    func drawFullLine(_ rect: CGRect) {
        
        // 获取图形上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 创建一个矩形 它的边距内缩3
        let drawingRect = rect.insetBy(dx: 10, dy: 10)
        
        // 创建并设置路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x: drawingRect.minX, y: drawingRect.minY))
        path.addLine(to: CGPoint(x: drawingRect.maxX, y: drawingRect.minY))
        path.addLine(to: CGPoint(x: drawingRect.maxX, y: drawingRect.maxY))
//        path.addLine(to: CGPoint(x: drawingRect.minX, y: drawingRect.maxY))
//        path.addLine(to: CGPoint(x: drawingRect.minX, y: drawingRect.minY))
        
        // 添加路径到图形上下文
        context.addPath(path)
        
        // 设置颜色
        context.setStrokeColor(UIColor.orange.cgColor)
        
        // 设置线宽
        context.setLineWidth(6)
        
        // 设置端点的样式
        /**
         .butt：不绘制端点，直接结束，默认值
         .round：绘制圆形端点， 线条结尾处绘制一个直径为线条宽度的半圆
         .square：线条结尾处绘制半个边长为线条宽度的正方形。这种形状的端点与“butt”形状的端点十分相似，只是线条略长一点而已。
         */
        context.setLineCap(.square)
        
        // 设置连接点的样式
        /**
         .miter：锐角斜切（默认值）
         .round：圆头
         .bevel：平头斜切
         */
        context.setLineJoin(.miter)
        
        // 设置阴影(偏移量、模糊度和颜色)
        context.setShadow(offset: .init(width: 3, height: 3), blur: 0.1, color: UIColor.lightGray.cgColor)
        
        
        // 绘制路径
        context.strokePath()
        
    }
    
    /// 绘制虚线
    func drawDottedLine(_ rect: CGRect) {
        
        // 获取图形上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        /**
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineDash(phase: 0, lengths: [3, 2])
        context.move(to: CGPoint(x: 10, y: 10))
        context.addLine(to: CGPoint(x: rect.width - 20, y: 10))
        context.strokePath()
        */
        
        // 创建设置路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: rect.maxX - 10, y: 10))
        path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.maxY - 10))
        
        // 添加路径到上下文
        context.addPath(path)
        
        // 设置颜色
        context.setStrokeColor(UIColor.orange.cgColor)
        
        // 设置线宽
        context.setLineWidth(6)
        
        // 虚线样式
        context.setLineDash(phase: 0, lengths: [5, 2])
        
        // 绘制路径
        context.strokePath()
        
    }
    
    /// 绘制圆弧
    func drawArc(_ rect: CGRect) {
        
        /** 绘制圆弧必须确定：
         圆心
         半径
         圆弧的起点角度和终点角度
         */
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let drawingRect = rect.insetBy(dx: 3, dy: 3)
        
        // 创建并设置路径
        let path = CGMutablePath()
        // 圆弧半径
        let radius = min(drawingRect.width, drawingRect.height) / 2 - 10
        // 圆弧中点
        let center = CGPoint(x: drawingRect.midX, y: drawingRect.midY)
        // 绘制圆弧
        /**
         clockwise：顺时针方向
         startAngle: 0 右边最端点
         endAngle：start和end方向都是顺时针角度到指定大小的位置
         clockwise：绘制方向（从end开始按clokwise方向绘制）
         */
//        path.addArc(center: center, radius: radius, startAngle: .pi * 0.25, endAngle: .pi * 0.75, clockwise: true)
        
        path.addArc(center: center, radius: radius, startAngle: 0, endAngle: .pi * 0.5, clockwise: true)
        
        // 添加路径到上下文
        context.addPath(path)
        
        // 颜色、线宽
        context.setStrokeColor(UIColor.orange.cgColor)
        context.setLineWidth(6)
        
//        context.setLineDash(phase: 0, lengths: [3, 1])
        
        // 绘制路径
        context.strokePath()
        
        
    }
    
    /// 贝赛尔曲线绘制
    func drawBezier(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let drawingRect = rect.insetBy(dx: 3, dy: 3)
        
        // 创建并设置路径
        let path = CGMutablePath()
        //移动起点
        path.move(to: CGPoint(x: drawingRect.minX, y: drawingRect.maxY))
        //三次贝塞尔曲线终点
        let toPoint = CGPoint(x: drawingRect.maxX, y: drawingRect.minY)
        //三次贝塞尔曲线第1个控制点
        let controlPoint1 = CGPoint(x: (drawingRect.minX+drawingRect.midX)/2, y: drawingRect.minY)
        //三次贝塞尔曲线第2个控制点
        let controlPoint2 = CGPoint(x: (drawingRect.midX+drawingRect.maxX)/2, y: drawingRect.maxY)
        //绘制三次贝塞尔曲线
        path.addCurve(to: toPoint, control1: controlPoint1, control2: controlPoint2)
        
        context.addPath(path)
        
        //设置笔触颜色
        context.setStrokeColor(UIColor.orange.cgColor)
        //设置笔触宽度
        context.setLineWidth(6)
         
        //绘制路径
        context.strokePath()
        
        
    }
    
}

fileprivate class ShapeView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawRectangle2(rect)
    }
    
    /// 绘制矩形
    func drawRectangle1(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let drawingRect = rect.insetBy(dx: 10, dy: 10)
        
        // 创建并设置路径
        let path = CGMutablePath()
        // 绘制矩形
//        path.addRect(drawingRect)
        // 绘制圆角的矩形
        path.addRoundedRect(in: drawingRect, cornerWidth: 10, cornerHeight: 10)
        
        // 添加路径到上下文
        context.addPath(path)
        
        // 设置上下文状态
        context.setLineWidth(6)
        context.setStrokeColor(UIColor.orange.cgColor)
        context.setFillColor(UIColor.blue.cgColor)
        
        // 绘制路径
//        context.strokePath()
        context.drawPath(using: .eoFillStroke)
        
    }
    
    /// 绘制圆形&椭圆
    func drawRectangle2(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // 创建并设置路径
        let path = CGMutablePath()
        let diameter = min(rect.width, rect.height)
//        path.addEllipse(in: CGRect(x: 5, y: 5, width: diameter - 10, height: diameter - 10))
        
        // 绘制正圆和绘制椭圆都是使用 addEllipse() 方法。如果宽高不一样就是椭圆形
        let drawingRect = rect.insetBy(dx: 10, dy: 10)
        path.addEllipse(in: drawingRect)
        
        // 添加路径到图形上下文
        context.addPath(path)
        
        // 设置上下文本属性
        context.setStrokeColor(UIColor.orange.cgColor)
        context.setLineWidth(6)
        context.setFillColor(UIColor.blue.cgColor)
        
        // 绘制路径并填充
        context.drawPath(using: .fillStroke)
        
    }
    
    
    
}

fileprivate class CanvasView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        /**
         UIBezierPath 类可以表示任何能够用 Bezier 曲线定义的形状，我们可以创建自己的自定义曲线。完成操作后，可以像其他路径一样，使用所得到的 UIBezierPath 对象进行填充和描边
         */
        
        // 创建一个矩形，它的所有边都内缩5%
        let drawingRect = self.bounds.insetBy(dx: rect.width * 0.05, dy: rect.height * 0.05)
        
        // 确定组成绘画的所有点
        let topLeft = CGPoint(x: drawingRect.minX, y: drawingRect.minY)
        let topRight = CGPoint(x: drawingRect.maxX, y: drawingRect.minY)
        let bottomRight = CGPoint(x: drawingRect.maxX, y: drawingRect.maxY)
        let bottomLeft = CGPoint(x: drawingRect.minX, y: drawingRect.maxY)
        let center = CGPoint(x: drawingRect.midX, y: drawingRect.midY)
        
        // 创建一个贝赛尔路径
        let bezierPath = UIBezierPath()
        bezierPath.move(to: topLeft)
        bezierPath.addLine(to: topRight)
        bezierPath.addLine(to: bottomLeft)
        bezierPath.addCurve(to: bottomRight, controlPoint1: center, controlPoint2: center)
        // 使路径闭合，结束绘制
        bezierPath.close()
        
        UIColor.green.setFill()
        UIColor.black.setStroke()
        bezierPath.fill()
        bezierPath.stroke()
        
    }
    
}

/// Core Graphics 绘制渐变色
fileprivate class GradientView: UIView {
    
    /**
     线性渐变：渐变色以直线方式从开始位置逐渐向结束位置渐变
     放射性渐变：以中心点为圆心从起始渐变色向四周辐射，直到终止渐变色
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.gradient1(rect)
    }
    
    /// 线性渐变
    func gradient1(_ rect: CGRect) {
    
        // 获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let compoents: [CGFloat] = [0xfc/255, 0x68/255, 0x20/255, 1,
                                    0xfe/255, 0xd3/255, 0x2f/255, 1,
                                    0xb1/255, 0xfc/255, 0x33/255, 1]
        // 每组颜色所在位置（范围0～1）
        let locations: [CGFloat] = [0, 0.5, 1]
        // 生成渐变色（count参数表示渐变个数）
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents, locations: locations, count: locations.count)!
        // 渐变开始位置
        let start = CGPoint(x: rect.minX, y: rect.minY)
        // 渐变结束位置
        let end = CGPoint(x: rect.maxX, y: rect.minY)
        // 绘制渐变
        context.drawLinearGradient(gradient, start: start, end: end, options: .drawsBeforeStartLocation)
        
    }
    
    /// 放射渐变
    func gradient2(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 使用rgb颜色空间
        let colorsSpace = CGColorSpaceCreateDeviceRGB()
        // 颜色数组(这里使用三组颜色作为渐变)fc6820
        let compoents: [CGFloat] = [0xFC / 255, 0x68 / 255, 0x20 / 255, 1,
                                    0xFE / 255, 0xD3 / 255, 0x2F / 255, 1,
                                    0xB1 / 255, 0xFC / 255, 0x33 / 255, 1]
        // 每组颜色所在的位置（范围0～1）
        let locations: [CGFloat] = [0.0, 0.5, 1.0]
        // 生成渐变色（count参数表示渐变个数）
        let gradient = CGGradient(colorSpace: colorsSpace, colorComponents: compoents, locations: locations, count: locations.count)!
        
        // 渐变圆心位置
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // 外圆半径
        let endRadius = min(rect.width, rect.height) / 2
        // 内圆半径
        let startRadius = endRadius / 3
        // 绘制渐变
        context.drawRadialGradient(gradient, startCenter: center, startRadius: startRadius, endCenter: center, endRadius: endRadius, options: .drawsBeforeStartLocation)
        
    }
    
    /**
     不管是线性渐变、还是放射性渐变，除了像上面那样直接绘制到背景上外，还可以填充绘制成任何的形状。
     首先我们自定义一个要填充的 path，无论是什么形状都可以。接着将其加入到 Context 中，用来做 Clip。最后在绘制渐变即可。
     */
    func gradient3(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 创建clip矩形
        let rect1 = CGRect(x: 0, y: 0, width: rect.width / 4, height: rect.height / 2)
        let rect2 = CGRect(x: rect.width / 4, y: rect.midY, width: rect.width / 4, height: rect.height / 2)
        let rect3 = CGRect(x: rect.width / 2, y: 0, width: rect.width / 4, height: rect.height / 2)
        let rect4 = CGRect(x: rect.width / 4 * 3, y: rect.midY, width: rect.width / 4, height: rect.height / 2)
        
        context.clip(to: [rect1, rect2, rect3, rect4])
        
        // 使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // 颜色数组（三组颜色）
        let compoents: [CGFloat] = [0xFC / 255, 0x68 / 255, 0x20 / 255, 1,
                                    0xFE / 255, 0xd3 / 255, 0x2F / 255, 1,
                                    0xB1 / 255, 0xFC / 255, 0x33 / 255, 1]
        // 每组颜色所在位置（范围0～1）
        let locations: [CGFloat] = [0, 0.5, 1]
        // 生成渐变色（count参数表示渐变个数）
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents, locations: locations, count: locations.count)!
        
        // 渐变开始位置
        let start = CGPoint(x: rect.minX, y: rect.minY)
        // 渐变结束位置
        let end = CGPoint(x: rect.maxX, y: rect.minY)
        // 绘制渐变
        context.drawLinearGradient(gradient, start: start, end: end, options: .drawsBeforeStartLocation)
        
    }
    
    /// 填充不规则图形
    func gradient4(_ rect: CGRect) {
        
        // 获取图形上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 创建路径设置路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        // 添加到图形上下文
        context.addPath(path)
        context.clip()
        
        // 使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // 颜色数组（这里使用三组颜色做为渐变）
        let compoents: [CGFloat] = [0xFC / 255, 0x68 / 255, 0x20 / 255, 1,
                                    0xFE / 255, 0xD3 / 255, 0x2F / 255, 1,
                                    0xB1 / 255, 0xFC / 255, 0x33 / 255, 1]
        // 每组颜色所在的位置（范围0～1）
        let locations: [CGFloat] = [0, 0.5, 1]
        // 生成渐变色（count参数表示渐变个数）
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents, locations: locations, count: locations.count)!
        
        // 渐变开始位置
        let start = CGPoint(x: rect.minX, y: rect.minY)
        // 渐变结束位置
        let end = CGPoint(x: rect.maxX, y: rect.minY)
        // 绘制渐变色
        context.drawLinearGradient(gradient, start: start, end: end, options: .drawsBeforeStartLocation)
        
    }
    
}

fileprivate class ImageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.image3(rect)
    }
    
    func image1(_ rect: CGRect) {
        
        let image = UIImage.dd.named("image")
        image?.draw(in: rect)
        
    }
    
    /// 从指定点开始绘制
    func image2(_ rect: CGRect) {
        
        let image = UIImage.dd.named("image")
        image?.draw(at: CGPoint(x: rect.midX, y: rect.midY))
        
    }
    
    /// 变换Transform的使用
    func image3(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 保存初始状态
        context.saveGState()
        
        // 变换1：向左向下平移10个点
        context.translateBy(x: 10, y: 10)
        // 变换2：缩放0.1
        context.scaleBy(x: 0.1, y: 0.1)
        // 变换3：旋转10度
        context.rotate(by: .pi / 18)
        
        // 获取图像
        let image = UIImage.dd.named("image")
        // 从指定点开始绘制
        image?.draw(at: CGPoint(x: 0, y: 0))
        
        // 恢复成初始状态
        context.restoreGState()
        
    }
    
}

fileprivate class TextView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.text2(rect)
    }
    
    func text1(_ rect: CGRect) {
        
        /**
         NSFontAttributeName 设置字体属性，默认值：12号的系统字体
         NSForegroundColorAttributeName 设置字体颜色，取值为 UIColor对象，默认为黑色
         NSBackgroundColorAttributeName 设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明
         NSLigatureAttributeName 设置连体属性，取值为整数，0 表示没有连体字符，1 表示使用默认的连体字符
         NSKernAttributeName 设定字符间距，取值为整数，正值间距加宽，负值间距变窄
         NSStrikethroughStyleAttributeName 设置删除线，取值为整数
         NSStrikethroughColorAttributeName 设置删除线颜色，取值为 UIColor 对象，默认值为黑色
         NSUnderlineStyleAttributeName 设置下划线，取值为整数，枚举常量 NSUnderlineStyle中的值，与删除线类似
         NSUnderlineColorAttributeName 设置下划线颜色，取值为 UIColor 对象，默认值为黑色
         NSStrokeWidthAttributeName 设置笔画宽度，取值为整数，负值填充效果，正值中空效果
         NSStrokeColorAttributeName 填充部分颜色，不是字体颜色，取值为 UIColor 对象
         NSShadowAttributeName 设置阴影属性，取值为 NSShadow 对象
         NSTextEffectAttributeName 设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用
         NSBaselineOffsetAttributeName 设置基线偏移值，取值为 float,正值上偏，负值下偏
         NSObliquenessAttributeName 设置字形倾斜度，取值为 float,正值右倾，负值左倾
         NSExpansionAttributeName 设置文本横向拉伸属性，取值为 float,正值横向拉伸文本，负值横向压缩文本
         NSWritingDirectionAttributeName 设置文字书写方向，从左向右书写或者从右向左书写
         NSVerticalGlyphFormAttributeName 设置文字排版方向，取值为整数，0 表示横排文本，1 表示竖排文本
         NSLinkAttributeName 设置链接属性，点击后调用浏览器打开指定URL地址
         NSAttachmentAttributeName 设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
         NSParagraphStyleAttributeName 设置文本段落排版格式，取值为 NSParagraphStyle 对象
         */
        
        let string = "欢迎来到ZJFund"
        // 文字样式
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                          NSAttributedString.Key.foregroundColor: UIColor.orange]
        
        // 绘制在指定区域
        (string as NSString).draw(in: rect, withAttributes: attributes)
        // 从指定点开始绘制
        (string as NSString).draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        
    }
    
    func text2(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 将坐标系上下翻转
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1, y: -1)
        
        // 创建并设置路径（排版区域）
        let path = CGMutablePath()
        // 绘制椭圆
        path.addEllipse(in: rect.insetBy(dx: 10, dy: 10))
        // 绘制边框
        context.addPath(path)
        context.strokePath()
        
        // 根据framesetter和绘图区域创建CTFrame
        let str = "欢迎访问dachun.com!欢迎访问hangge.com!欢迎访问hangge.com!欢迎访问hangge.com!欢迎访问hangge.com!欢迎访问hangge.com!欢迎访问dachun.com!欢迎访问hangge.com!欢迎访问hangge.com!欢迎访问hangge.com!欢迎访问hangge.com!欢迎访问hangge.com!"
        let attrString = NSMutableAttributedString(string: str)
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        
        // 使用CTFrameDraw进行绘制
        CTFrameDraw(frame, context)
        
        // 恢复成初始状态
        context.restoreGState()
        
    }
    
}

// ******************************************** Core Graphics **************************************


// ******************************************** UIView draw **************************************

/**
 UIBezierPath
 */

fileprivate class ZJView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.draw4(rect)
    }
    
    /// 纯色填充的矩形
    func draw1(_ rect: CGRect) {
    
        UIColor.green.setFill()
        let path = UIBezierPath(rect: rect)
        path.fill()
        
    }
    
    /// 圆角边框
    func draw2(_ rect: CGRect) {
        
        let pathRect = CGRectInset(rect, 1, 1)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 10)
        path.lineWidth = 3
        UIColor.green.setFill()
        UIColor.blue.setStroke()
        path.fill()
        path.stroke()
        
    }
    
    func draw3(_ rect: CGRect) {
        
        let squareRect = rect.insetBy(dx: rect.width * 0.05, dy: rect.height * 0.45)
        
        let circleRect = rect.insetBy(dx: rect.width * 0.3, dy: rect.height * 0.3)
        
        // 创建一条空的bezier路径作为主路径
        let bezierPath = UIBezierPath()
        
        // 创建子路径
        let circlePath = UIBezierPath(ovalIn: circleRect)
        let squarePath = UIBezierPath(roundedRect: squareRect, cornerRadius: 20)
        
        // 将他们添加到主路径
        bezierPath.append(circlePath)
        bezierPath.append(squarePath)
        
        // 设定颜色
        UIColor.green.setFill()
        UIColor.black.setStroke()
        bezierPath.fill()
        
    }
    
    func draw4(_ rect: CGRect) {
        
        /**
         //获取绘制上下文
                 let context = UIGraphicsGetCurrentContext()
                  
                 //计算要在其中绘制的矩形
                 let pathRect = CGRectInset(self.bounds,
                     self.bounds.size.width * 0.1,
                     self.bounds.size.height * 0.1)
                  
                 //创建一个圆角矩形路径
                 let rectanglePath = UIBezierPath(roundedRect: pathRect, cornerRadius: 20)
                  
                 //保存绘制设置
                 CGContextSaveGState(context)
                  
                 //准备阴影
                 let shadowColor = UIColor.blackColor().CGColor
                 let shadowOffet = CGSize(width: 3, height: 3)
                 let shadowBlurRadius:CGFloat = 5.0
                  
                 //创建和应用阴影
                 CGContextSetShadowWithColor(context, shadowOffet, shadowBlurRadius, shadowColor)
                  
                 //绘制带有阴影的路径
                 UIColor.blueColor().setFill()
                 rectanglePath.fill()
                  
                 //还原绘制设置
                 CGContextRestoreGState(context)
                  
                 //绘制另一个矩形（不带阴影）
                 let pathRect2 = CGRectInset(self.bounds,
                     self.bounds.size.width * 0.3,
                     self.bounds.size.height * 0.3)
                 let rectanglePath2 = UIBezierPath(rect: pathRect2)
                 UIColor.yellowColor().setFill()
                 rectanglePath2.fill()
         */
        
        // 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let pathRect = CGRectInset(rect, 100, 100)
        
        // 创建一个圆角矩形路径
        let rectanglePath = UIBezierPath(roundedRect: pathRect, cornerRadius: 20)
        
        // 保存绘制设置
        context.saveGState()
        
        // 阴影
        let shadowColor = UIColor.black.cgColor
        let shadowOffset = CGSize(width: 3, height: 3)
        let shadowBlurRadius: CGFloat = 5.0
        
        context.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadowColor)
        
        // 绘制带有阴影的路径
        UIColor.blue.setFill()
        rectanglePath.fill()
        
        context.restoreGState()
        
        //绘制另一个矩形（不带阴影）
        let pathRect2 = CGRectInset(self.bounds,
            self.bounds.size.width * 0.3,
            self.bounds.size.height * 0.3)
        let rectanglePath2 = UIBezierPath(rect: pathRect2)
        UIColor.yellow.setFill()
        rectanglePath2.fill()
        
        
    }
    
}

// ******************************************** UIBezierPath *********************************
/**
 UIBezierPath是UIKit Core Grephics 对path的封装
 可以绘制各种简单的图形：直线，折线，多边形，圆，圆弧，虚线...等等
 延伸场景：动画，图表...等
 */

fileprivate class ZJBezierView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.bezier6(rect)
    }
    
    func bezier1(_ rect: CGRect) {
    
        UIColor.red.set()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 30, y: 30))
        path.addLine(to: CGPoint(x: 200, y: 80))
        path.addLine(to: CGPoint(x: 150, y: 150))
        
        path.lineWidth = 5
        path.lineCapStyle = .square
        path.lineJoinStyle = .round
        
        path.stroke()
        
    }
    
    /// 绘制实线
    func bezier2(_ rect: CGRect) {
        
        UIColor.orange.set()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.midY))
        
        path.lineWidth = 1
        path.lineCapStyle = .square
        
        path.stroke()
        
    }
    
    /// 绘制虚线
    func bezier3(_ rect: CGRect) {

        UIColor.red.set()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.midY))

        path.lineWidth = 5
        path.setLineDash([2, 5], count: 2, phase: 0)

        path.stroke()

    }

    func bezier4(_ rect: CGRect) {

        UIColor.red.set()

        let path = UIBezierPath(arcCenter: self.center, radius: 80, startAngle: .pi, endAngle: 2 * .pi, clockwise: true)
        path.setLineDash([2, 5], count: 2, phase: 0)
        path.lineWidth = 10
        path.stroke()

    }
    
    /// 绘制多边形
    func bezier5(_ rect: CGRect) {
        
        UIColor.red.set()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50, y: 100))
        path.addLine(to: CGPoint(x: 150, y: 50))
        path.addLine(to: CGPoint(x: 250, y: 100))
        path.addLine(to: CGPoint(x: 250, y: 200))
        path.addLine(to: CGPoint(x: 100, y: 200))
        path.close()
        
        path.lineWidth = 5
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
//        path.stroke()
        path.fill()
        
    }
    
    /// 绘制矩形 & 带内切角的矩形 & 指定内切角
    func bezier6(_ rect: CGRect) {
        
        UIColor.red.set()
        
        let drawingRect = rect.insetBy(dx: 20, dy: 20)
//        let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: 20)
        let path = UIBezierPath(roundedRect: drawingRect, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 20, height: 20))
        
        path.lineWidth = 5
        path.lineCapStyle = .round // 终点处理
        path.lineJoinStyle = .round // 拐点处理
        
        path.fill()
        
    }
    
    /// 圆和椭圆
    func bezier7(_ rect: CGRect) {
        
        UIColor.red.set()
        
        let path = UIBezierPath(ovalIn: CGRect(x: 100, y: 80, width: 150, height: 150))
        path.lineWidth = 5
        
        path.stroke()
        
    }
    
    /// 绘制圆弧
    func bezier8(_ rect: CGRect) {
        
        UIColor.red.set()
        
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 100, startAngle: 1.25 * .pi, endAngle: 1.75 * .pi, clockwise: true)
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.close()
        
        path.lineWidth = 6
        
        path.stroke()
        
    }
    
    /// 绘制二次曲线三次曲线
    func bezier9(_ rect: CGRect) {
        
        UIColor.red.set()
        
        let path = UIBezierPath()
        
//        path.move(to: CGPoint(x: 100, y: 200))
//        path.addQuadCurve(to: CGPoint(x: 250, y: 200), controlPoint: CGPoint(x: 50, y: 40))
        
        path.move(to: CGPoint(x: 50, y: 150))
        path.addCurve(to: CGPoint(x: 260, y: 150), controlPoint1: CGPoint(x: 140, y: 0), controlPoint2: CGPoint(x: 140, y: 300))
        
        path.lineWidth = 5
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
    
        path.stroke()
        
        
    }
    

}
