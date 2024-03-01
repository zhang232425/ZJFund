//
//  ZJAnimationVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/27.
//

import UIKit

// https://www.hangge.com/blog/cache/detail_1072.html
// https://blog.51cto.com/u_16124099/6338911
// https://www.hangge.com/blog/cache/detail_664.html

// https://www.jianshu.com/p/9aead7675221

/// 推荐核心动画 https://zsisme.gitbooks.io/ios-/content/chapter1/the-layer-tree.html

/**
 iOS动画方案：
 1、UIView animation
 2、CoreAnimation
    2.1 CABasicAnimation 基础动画
    2.2 CAKeyframeAnimation 关键帧动画
    2.3 CATransition 转场动画
    2.4 CAAnimationGroup 组动画
    2.5 CASpringAnimation 弹性动画（iOS 9.0 之后，它实现弹簧效果动画，是CABaseAnimation的子类）
 */

class ZJAnimationVC: BaseVC {
    
    var square: UIView!

    private lazy var startBtn = UIButton(type: .system).then {
        $0.setTitle("开始", for: .normal)
    }
    
    private var animationView: UIView!
    
    private var label1: UILabel!
    private var label2: UILabel!
    private var label3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
}

private extension ZJAnimationVC {
    
    func setupViews() {

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: startBtn)
        
//        animationView.add(to: view).snp.makeConstraints {
//            $0.left.top.equalToSuperview().inset(50)
//            $0.size.equalTo(100)
//        }
        
//        animationView.frame = .init(x: 50, y: 50, width: 100, height: 100)
//        view.addSubview(animationView)
        
        /*
        label1 = self.getLabel(frame: .init(x: 0, y: 70, width: 130, height: 30), text: "curveEaseIn")
        view.addSubview(label1)
        
        label2 = self.getLabel(frame: .init(x: 0, y: 120, width: 130, height: 30), text: "autoreverse")
        view.addSubview(label2)
        
        label3 = self.getLabel(frame: .init(x: 0, y: 170, width: 130, height: 30), text: "curveEaseOut")
        view.addSubview(label3)
         */
        
        /*
        label1 = getLabel(frame: CGRect(x: 10, y: 70, width: 100, height: 100), text: "dampingRatio = 0.1\nvelocity = 5")
        view.addSubview(label1)

        label2 = getLabel(frame: CGRect(x: 120, y: 70, width: 100, height: 100), text: "dampingRatio = 0.3\nvelocity = 3")
        view.addSubview(label2)

        label3 = getLabel(frame: CGRect(x: 230, y: 70, width: 100, height: 100), text: "dampingRatio = 0.5\nvelocity = 1")
        view.addSubview(label3)
         */
        
        animationView = UIView(frame: .init(x: 50, y: 70, width: 100, height: 100))
        animationView.center = view.center
        animationView.backgroundColor = .blue
        view.addSubview(animationView)
        
    }
    
    func bindActions() {
        
        startBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.test4()
        }).disposed(by: disposeBag)
        
    }
    
}

// MARK: - 普通动画

/**
frame，实现移动的动画效果
bounds，实现内部子控件移动的动画效果
center，实现移动的动画效果
alpha，实现淡入淡出的动画效果
backgroundColor，实现背景色渐变的动画效果
transform，实现移动、缩放、旋转的动画效果，详见iOS CGAffineTransform仿射变换
 */

/** 参数说明：
 duration：动画持续时间
 delay：动画延迟执行的时间
 UIView.AnimationOptions：动画的过渡效果，可以组合使用。
 animations：执行的动画
 completion：执行动画完成之后的操作
 */

/** UIView.AnimationOptions：参数说明
 curveEaseInOut：时间曲线，慢速开始，然后加速，最后减速（默认值）
 curveEaseIn：时间曲线，慢速开始，之后越来越快
 curveEaseOut：时间曲线，快速开始，之后越来越慢
 curveLinear：时间曲线，匀速
 repeat：指定这个选项后，动画会无限重复
 autoreverse：往返动画，从开始执行到结束后，又从结束返回开始
 preferredFramesPerSecond30：指定动画刷新频率为30fps
 preferredFramesPerSecond60：指定动画刷新频率为60fps
 */

private extension ZJAnimationVC {
    
    func animation1() {
        
        UIView.animate(withDuration: 0.5) {
            self.animationView.backgroundColor = .orange
        }
        
    }
    
    /**
     问题一：再原来的frame基础之上，我改变位置，又改变大小，是否能做到
     */
    func animation2() {
        
        UIView.animate(withDuration: 0.5) {
            self.animationView.backgroundColor = .blue
            self.animationView.center.y += 100
            self.animationView.alpha = 0.5
//            self.animationView.frame.size.width = 200
        }
        
    }
    
    func animation3() {
        
        UIView.animate(withDuration: 0.5) {
            self.animationView.backgroundColor = .blue
        } completion: { _ in
            print("动画执行完毕")
        }

    }
    
    func animation4() {
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveLinear, animations: {
            self.animationView.backgroundColor = .blue
        }, completion: { _ in
            print("动画执行完毕")
        })
        
    }
    
    func animation5() {
        
        UIView.animate(withDuration: 2, delay: 0, options: .preferredFramesPerSecond30 ,animations: {
            self.animationView.frame = .init(x: 50, y: 550, width: 100, height: 100)
        })
        
    }
    
    // https://www.jianshu.com/p/97909c944114
    
    /// frame有动画效果，不能使用auto
    func frame() {
        
        UIView.animate(withDuration: 1) {
            self.animationView.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        }
        
    }
    
    func bounds() {
        
        UIView.animate(withDuration: 1) {
            self.animationView.bounds = .init(x: 200, y: 150, width: 100, height: 100)
        }
        
    }
    
    func center() {
        
        UIView.animate(withDuration: 1) {
            self.animationView.center = self.view.center
        }
        
    }
    
    func transform() {
        
        UIView.animate(withDuration: 1) {
            // CGAffineTransformMakeRotation(M_PI_4);
            self.animationView.transform = CGAffineTransformMakeRotation(.pi)
        }
        
    }
    
}

private extension ZJAnimationVC {
    
    func test1() {
        
        UIView.animate(withDuration: 2) {
            self.animationView.frame = .init(x: 150, y: 150, width: 100, height: 100)
        } completion: { isFinish in
            if isFinish {
                self.animationView.backgroundColor = .blue
            }
        }
        
    }
    
    func test2() {
        
        UIView.animate(withDuration: 2, delay: 1, options: [.repeat, .curveEaseIn]) {
            self.label1.frame = .init(x: 250, y: 70, width: 130, height: 30)
        }
        
        UIView.animate(withDuration: 2, delay: 1, options: [.repeat, .autoreverse]) {
            self.label2.frame = .init(x: 250, y: 120, width: 130, height: 30)
        }
        
        UIView.animate(withDuration: 2, delay: 1, options: [.repeat, .curveEaseOut]) {
            self.label3.frame = .init(x: 250, y: 170, width: 130, height: 30)
        }
        
    }
    
    // 弹簧动画
    func test3() {
        
        UIView.animate(withDuration: 3, delay: 1, usingSpringWithDamping: 0.1, initialSpringVelocity: 5) {
            self.label1.frame = .init(x: 10, y: 370, width: 100, height: 100)
        } completion: { isFinish in
            if isFinish {
                self.label1.backgroundColor = .red
            }
        }
        
        UIView.animate(withDuration: 3, delay: 1, usingSpringWithDamping: 0.3, initialSpringVelocity: 3) {
            self.label2.frame = .init(x: 120, y: 370, width: 100, height: 100)
        } completion: { isFinish in
            if isFinish {
                self.label2.backgroundColor = .red
            }
        }
        
        UIView.animate(withDuration: 3, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1) {
            self.label3.frame = .init(x: 230, y: 370, width: 100, height: 100)
        } completion: { isFinish in
            if isFinish {
                self.label3.backgroundColor = .red
            }
        }
        
    }
    
    // 过渡动画
    func test4() {
    
        /// 刚刚view.addSubview(view1)后，如果不延迟后执行，options设置的动画效果无效
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            UIView.transition(with: self.animationView, duration: 3, options: [.transitionCurlUp]) {
                self.animationView.backgroundColor = .yellow
            } completion: { isFinish in
                 if isFinish {
                     self.animationView.backgroundColor = .red
                 }
            }
        }

    }
    
    func getLabel(frame: CGRect, text: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = .systemFont(ofSize: 15)
        label.backgroundColor = .blue
        label.textColor = .white
        label.textAlignment = .center
        label.text = text
        return label
    }
    
}

/// 弹簧动画，又称spring动画
/**
 dampingRation：震动效果，范围0～1，数值越小震动效果越明显
 velocity：初始速度，数值越大初始速度越快
 */
private extension ZJAnimationVC {
    
    func spring1() {
        
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 20, options: .curveEaseIn) {
            self.animationView.center.y += 100
        }
        
    }
    
}

