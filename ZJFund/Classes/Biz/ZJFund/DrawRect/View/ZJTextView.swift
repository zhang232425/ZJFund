//
//  ZJTextView.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/29.
//

import UIKit

class ZJTextView: UIView {

    private lazy var textLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.add(to: self).snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let text: NSString = "这是一段绘制文本、这是一段绘制文本、这是一段绘制文本、这是一段绘制文本、这是一段绘制文本、这是一段绘制文本、这是一段绘制文本"
        var style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping // 结尾部分的内容以...方式省略 （"...xxx", "asv...", "as...yx"）
        style.alignment = .left //文本对其方式
        style.lineSpacing = 8 // 字体的行间距
        style.firstLineHeadIndent = 35 // 首行缩进
        style.headIndent = 0.0 // 整体缩进
        style.tailIndent = 0.0 // 尾部缩进
        style.minimumLineHeight = 40.0 // 最低行高
        style.maximumLineHeight = 40.0 // 最大行高
        style.paragraphSpacing = 15.0 // 段与段之间的间距
        style.paragraphSpacingBefore = 22.0 // 段首行空白空间
        style.baseWritingDirection = .leftToRight   // 从左到右的书写方向
        style.lineHeightMultiple = 15
        style.hyphenationFactor = 1 //连字属性 在iOS，唯一支持的值分别为0和1
        // 文本属性
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                          NSAttributedString.Key.foregroundColor: UIColor.red]
        
        // 绘制文字 drawInRect
        text.draw(in: rect, withAttributes: attributes)
        
        self.textLabel.text = String(text)
        
    }
    
}
