//
//  CAGradientLayerVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/29.
//

import UIKit
import ZJExtension

class CAGradientLayerVC: BaseVC {
    
    private lazy var meter = TemperatureMeter().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var slider = UISlider().then {
        $0.addTarget(self, action: #selector(change), for: .valueChanged)
    }
    
    private lazy var progressView = RainboewProgressView()
    
//    private lazy var slider = UISlider()
    
    private lazy var switchBtn = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "测试", style: .plain, target: self, action: #selector(textClick))
        
        progressView.add(to: view).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(50.auto)
            $0.height.equalTo(5)
        }
        
        slider.add(to: view).snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(50)
            $0.left.right.equalTo(progressView)
        }
        
        switchBtn.add(to: view).snp.makeConstraints {
            $0.top.equalTo(slider.snp.bottom).offset(50)
            $0.centerY.equalToSuperview()
        }
        
        
    }
    
    @objc func textClick() {
        
        gradient()
        
    }
    
    @objc func change() {
        
//        meter.setPercent(percent: CGFloat(slider.value))
        self.progressView.progressValue = CGFloat(slider.value)
        
    }
    
    func gradient() {
        
//        meter.add(to: view).snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.size.equalTo(200)
//        }
//
//        slider.add(to: view).snp.makeConstraints {
//            $0.width.equalTo(200)
//            $0.centerX.equalToSuperview()
//            $0.bottom.equalToSuperview().inset(100)
//        }
        
//        TextView().add(to: view).snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
        
//        TextRollView().add(to: view).snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
        
        RainbowView().add(to: view).snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(150)
        }
        
    }

}


/// locations 变化动画
fileprivate class TextRollView: UIView {
    
    private lazy var label = UILabel().then {
        $0.text = "学习，锻炼，泡妞"
        $0.font = UIFont.bold20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        label.add(to: self).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.cgColor, UIColor.white.cgColor, UIColor.black.cgColor]
        layer.locations = [0, 0, 0.25]
        
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        
        layer.frame = self.bounds
        
        self.layer.insertSublayer(layer, at: 0)
        
        // 添加渐变动画
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, 0, 0.2]
        animation.toValue = [0.8, 1, 1]
        animation.duration = 3.7
        // 动画一直重复
        animation.repeatCount = HUGE
        
        layer.add(animation, forKey: nil)
        
        self.mask = self.label
        
    }
    
}

/// 彩虹圆环
fileprivate class RainbowView: UIView, CAAnimationDelegate {
    
    private lazy var gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // 设置渐变层颜色
        var rainBowColors: [CGColor] = []
        var hue: CGFloat = 0
        while hue <= 360 {
            let color = UIColor(hue: 1.8 * hue / 360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            rainBowColors.append(color.cgColor)
            hue += 5
        }
        
        gradientLayer.colors = rainBowColors
        
        self.layer.addSublayer(gradientLayer)
        
        // 创建遮罩
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: 30, dy: 30)).cgPath
        maskLayer.strokeColor = UIColor.gray.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.lineWidth = 30
        
        gradientLayer.mask = maskLayer
        
        performAnimation()
        
    }
    
    func performAnimation() {
        
        // 更新渐变层的颜色
        let fromColors = gradientLayer.colors as! [CGColor]
        let toColors = self.shiftColors(colors: fromColors)
        gradientLayer.colors = toColors
        
        // 动画
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = 0.1
        animation.fromValue = fromColors
        animation.toValue = toColors
        // 动画完成后是否要移除
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        // 将动画添加到图层中
        gradientLayer.add(animation, forKey: "colors")
        
    }
    
    // 将颜色数组中的最后一个元素移动到数组的最前面
    func shiftColors(colors: [CGColor]) -> [CGColor] {
        
        var newColors: [CGColor] = colors.map { ($0.copy())! }
        // 获取最后一个元素
        let last: CGColor = newColors.last!
        // 将最后一个元素删除
        newColors.removeLast()
        // 将最后一个元素插入到头部
        newColors.insert(last, at: 0)
        
        return newColors
    }
    
    // 动画播放结束之后相应
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        performAnimation()
    }
    
}

/// 彩虹进度条
fileprivate class RainboewProgressView: UIView, CAAnimationDelegate {
    
    /// 当前是否播放动画
    var isAnimating = false
    
    /// 渐变层
    var gradientLayer: CAGradientLayer!
    
    /// 遮罩层
    var maskLayer: CAShapeLayer!
    
    // 当前进度
    var _progressValue: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = bounds
        
        // 设置渐变层颜色
        var rainBowColors: [CGColor] = []
        var hue: CGFloat = 0
        while hue <= 360 {
            let color = UIColor(hue: 1.0 * hue / 360, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            rainBowColors.append(color.cgColor)
            hue += 5
        }
        gradientLayer.colors = rainBowColors
        
        // 添加遮罩
        let shapePath = UIBezierPath()
        shapePath.move(to: CGPoint(x: 0, y: 0))
        shapePath.addLine(to: CGPoint(x: bounds.width, y: 0))
        
        maskLayer = CAShapeLayer()
        maskLayer.path = shapePath.cgPath
        maskLayer.lineWidth = bounds.height
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        
        // 遮罩层的起始、终止位置都为0
        maskLayer.strokeStart = 0
        maskLayer.strokeEnd = 0
        
        // 设置遮罩层
        gradientLayer.mask = maskLayer
        
    }
    
    // 执行动画
    func performAnimation() {
        
        let fromColors = gradientLayer.colors as! [CGColor]
        let toColors = self.shiftColors(colors: fromColors)
        gradientLayer.colors = toColors
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 0.08
        
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        
        layer.add(animation, forKey: "animateGradient")
        
    }
    
    //将颜色数组中的最后一个元素移到数组的最前面
    func shiftColors(colors:[CGColor]) -> [CGColor] {
        //复制一个数组
        var newColors: [CGColor] = colors.map{($0.copy()!) }
        //获取最后一个元素
        let last: CGColor = newColors.last!
        //将最后一个元素删除
        newColors.removeLast()
        //将最后一个元素插入到头部
        newColors.insert(last, at: 0)
        //返回新的颜色数组
        return newColors
    }
    
    //动画播放结束后的响应
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //根据isAnimating属性判断是否还有继续播放动画
        if isAnimating {
            self.performAnimation()
        }
    }
    
    func startAnimating() {
        if !isAnimating {
            self.isAnimating = true
            self.performAnimation()
        }
    }
    
    func stopAnimating() {
        if isAnimating {
            self.isAnimating = false
        }
    }
    
    var progressValue: CGFloat {
        get {
            return _progressValue
        }
        set {
            _progressValue = newValue > 1 ? 1 : newValue
            _progressValue = newValue < 0 ? 0 : newValue
            self.maskLayer.strokeEnd = _progressValue
        }
    }
    
}


/*
class CAGradientLayerVC: BaseVC, UITableViewDataSource {
    
    private lazy var containerView = UIView()
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.registerCell(TestCell.self)
        $0.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        containerView.add(to: view).snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalTo(300)
            $0.top.equalTo(100)
            $0.height.equalTo(600)
        }
        
        tableView.add(to: containerView).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    
        // 创建渐变层
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 100, width: 300, height: 600)
        gradientLayer.locations = [0, 0.5, 1]

        containerView.layer.mask = gradientLayer
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        37
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TestCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
        cell.update("  游客\(Int(arc4random()%100) + 100)：这是一条弹幕消息")
        return cell
    }
    
}
 */

/*
class CAGradientLayerVC: BaseVC, CAAnimationDelegate {

    let colors = [
        [UIColor.yellow.cgColor, UIColor.orange.cgColor],
        [UIColor.cyan.cgColor, UIColor.green.cgColor],
        [UIColor.magenta.cgColor, UIColor.blue.cgColor]
    ]
    
    var currentIndex = 0
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
    
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(singleClick)))
        
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors[0]
        gradientLayer.locations = [0.0, 1.0]
        
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    @objc func singleClick() {
        
        var nextIndex = currentIndex + 1
        if nextIndex >= colors.count {
            nextIndex = 0
        }
        
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.delegate = self
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.fromValue = colors[currentIndex]
        colorChangeAnimation.toValue = colors[nextIndex]
        colorChangeAnimation.fillMode = kCAFillModeForwards
        // 动画结束之后保持最终的效果
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
        
        // 动画播放后改变当前索引值
        currentIndex = nextIndex
        
    }
    
}
*/

// locations 变化动画

/*
class CAGradientLayerVC: BaseVC {

    private lazy var label = UILabel().then {
        $0.font = UIFont.bold18
        $0.text = "学习，锻炼，泡妞"
    }
    
    private lazy var containerView = UIView()
    
    private lazy var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.darkGray
        
        containerView.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        containerView.add(to: view)
        label.frame = containerView.bounds
        label.add(to: containerView)
        
        self.gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor, UIColor.black.cgColor]
        
        //设置每种颜色初始所在的位置
        self.gradientLayer.locations = [0, 0, 0.25]
         
        //设置渲染的起始结束位置（横向渐变）
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
         
        //设置其CAGradientLayer对象的frame，并插入view的layer
        self.gradientLayer.frame = CGRect(x: 0, y: 0,
                                          width: containerView.frame.size.width,
                                          height: containerView.frame.size.height)
         
        //将渐变层添加到文本标签背景上
        self.containerView.layer.insertSublayer(gradientLayer, at: 0)
         
        //添加渐变动画（让白色光泽从左向右移动）
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0, 0, 0.2]
        gradientAnimation.toValue = [0.8, 1, 1]
        gradientAnimation.duration = 12.5
        //动画一致重复执行
        gradientAnimation.repeatCount = HUGE
        self.gradientLayer.add(gradientAnimation, forKey: nil)
         
        //设置遮罩，让渐变层透过文字显示出来
        self.containerView.mask = self.label
        
    }
    
    
    
}
 */

fileprivate class TestCell: UITableViewCell {
    
    private lazy var label = UILabel().then {
        $0.font = UIFont.regular11
        $0.textColor = .white
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        $0.layer.cornerRadius = 9
        $0.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        label.add(to: contentView).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
    }
    
    func update(_ text: String) {
        
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange], range: NSMakeRange(0, 8))
        label.attributedText = attributeString
        
        
    }
    
}

fileprivate class GradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.darwGradient2(bounds)
    }
    
    /// 两个颜色渐变
    func darwGradient1(_ rect: CGRect) {
        
        // 定义渐变颜色（黄色到橙色）
        let topColor = UIColor(red: 0xFE / 255, green: 0xD3 / 255, blue: 0x2F / 255, alpha: 1)
        let bottomColor = UIColor(red: 0xFC / 255, green: 0x68 / 255, blue: 0x20 / 255, alpha: 1)
        let gradientColors = [topColor.cgColor, bottomColor.cgColor]
        
        // 定义每种颜色所在的位置
        let locations: [NSNumber] = [0, 1.0]
        
        // 创建CAGradientLayer对象并设置参数
        let layer = CAGradientLayer()
        layer.colors = gradientColors
        layer.locations = locations
        // 启始位置
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        
        layer.frame = rect
        
        self.layer.insertSublayer(layer, at: 0)
        
    }
    
    /// 多个颜色渐变
    func darwGradient2(_ rect: CGRect) {
    
        let colors = [UIColor.red.cgColor,
                      UIColor.orange.cgColor,
                      UIColor.yellow.cgColor,
                      UIColor.green.cgColor,
                      UIColor.cyan.cgColor,
                      UIColor.blue.cgColor,
                      UIColor.purple.cgColor]
        
        let layer = CAGradientLayer()
        layer.colors = colors
        layer.locations = [0.0, 0.17, 0.33, 0.5, 0.67, 0.83, 1.0]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        
        layer.frame = rect
        
        self.layer.insertSublayer(layer, at: 0)
        
    }
    
}

fileprivate class TemperatureMeter: UIView {
    
    /// 进度条所在圆的直径
    let progressDiameter: CGFloat = 200
    
    /// 进度条线条宽度
    let progressWidth: CGFloat = 5
    
    /// 进度条轨道颜色
    let trackColor = UIColor.lineColor
    
    /// 渐变进度条
    var progressLayer: CAShapeLayer!
    
    /// 进度文本标签
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        // 创建文本标签
        label = UILabel().then({
            $0.text = "0℃"
            $0.textAlignment = .center
        })
        
        label.add(to: self).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 轨道以及上面进度条的路径(在组件内部水平居中)
        let path = UIBezierPath(arcCenter: CGPoint(x: 100, y: 100),
                                radius: (progressDiameter - progressWidth) / 2,
                                startAngle: toRadians(degress: -210),
                                endAngle: toRadians(degress: 30),
                                clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.frame = self.bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.opacity = 1
        trackLayer.lineCap = kCALineCapRound
        trackLayer.lineWidth = progressWidth
        
        trackLayer.path = path.cgPath

        self.layer.addSublayer(trackLayer)
        
        // 绘制进度条
        progressLayer = CAShapeLayer()
        progressLayer.frame = self.bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.lineCap = kCALineCapRound
        progressLayer.lineWidth = progressWidth
        
        progressLayer.path = path.cgPath
        // 默认结束位置是0
        progressLayer.strokeEnd = 0
        
        self.layer.addSublayer(progressLayer)
        
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.frame = CGRect(x: 0, y: 0, width: 100, height: progressDiameter / 4 * 3 + progressWidth)
        gradientLayer1.colors = [UIColor.yellow.cgColor, UIColor.blue.cgColor]
        gradientLayer1.locations = [0.0, 1.0]
        
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.frame = CGRect(x: 100, y: 0, width: 100, height: progressDiameter / 4 * 3 + progressWidth)
        gradientLayer2.colors = [UIColor.yellow.cgColor, UIColor.red.cgColor]
        gradientLayer2.locations = [0.0, 1.0]
        // container
        let containerLayer = CALayer()
        containerLayer.addSublayer(gradientLayer1)
        containerLayer.addSublayer(gradientLayer2)
        self.layer.addSublayer(containerLayer)
        
        // 将渐变层的遮罩设置为进度条
        containerLayer.mask = progressLayer
        
    }
    
    /// 设置进度
    func setPercent(percent: CGFloat, animated: Bool = true) {
        
        print("percent === ", percent)
        
        progressLayer.strokeEnd = percent
        
        label.text = String(format: "%.1f", percent * 100)
//        label.text = "\(Int(percent * 100))℃"
        
    }
    
    /// 把角度转换成弧度
    func toRadians(degress: CGFloat) -> CGFloat {
        .pi * (degress) / 180
    }
    
}

fileprivate class TextView: UIView {
    
    private lazy var label = UILabel().then {
        $0.text = "zhangdachun.com"
        $0.font = UIFont.bold30
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topColor = UIColor(red: 0xFE / 255, green: 0xD3 / 255, blue: 0x2F / 255, alpha: 1)
        let bottomColor = UIColor(red: 0xFC / 255, green: 0x68 / 255, blue: 0x20 / 255, alpha: 1)
        let colors = [topColor.cgColor, bottomColor.cgColor]
        
        let layer = CAGradientLayer()
        layer.colors = colors
        layer.locations = [0.0, 1.0]
        
        layer.frame = bounds
        self.layer.insertSublayer(layer, at: 0)
        
        layer.mask = label.layer
        
    }
    
    func setupViews() {
        
        label.add(to: self).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}
