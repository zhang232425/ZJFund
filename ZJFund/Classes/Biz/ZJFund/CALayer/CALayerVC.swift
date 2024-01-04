//
//  CALayerVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/21.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxSwiftExt

/** https://juejin.cn/post/7285290243297689652
 CALayer
 Core Animation
 Core Graphics
 UIResponder
 */

/** Core Animation
 
 CAAnimation
 CAPropertyAnimation（CABasicAnimation 和 CAKeyframeAnimation）
 CAAnimationGroup
 CATransition
 */

/** CALayer
 CALayer:与UIView属性类似，可使用CGImage填充、控制颜色、位置、动画
 CATextLayer:绘制String或者AttributeString
 CAShapLayer:具有path属性，与图形上下文属性相似
 CAGradientLayer:梯度层，颜色渐变
 CAEmitterLayer:发射器层，控制粒子或者散列效果
 CAEAGLayer:openGL ES绘制层
 ...
 */

class CALayerVC: BaseListVC {
    
    private let datas = BehaviorRelay(value: [SectionModel(model: "", items: ["DrawRect", "View mask", "UIResponder", "CAGradientLayer", "CAShapeLayer", "CoreGraphics", "CoreAnimation", "Transform"])])
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindData()
    }
    
}

private extension CALayerVC {
    
    func config() {
        
        self.navigationItem.title = "UIView与CALayer"
        
    }
    
    func setupViews() {
        
        tableView.then {
            $0.registerCell(VendorsCell.self)
        }.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindData() {
        
        bindListDataSource()
        
        tableView.rx.modelSelected(String.self).subscribeNext(weak: self, CALayerVC.rowClick).disposed(by: disposeBag)
        
    }
    
    func bindListDataSource() {
        
        dataSource = .init(configureCell: { (ds, tableView, indexPath, item) in
            
            let cell: VendorsCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.update(with: item)
            return cell
            
        })
        
        datas.observe(on: MainScheduler.instance).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
}

private extension CALayerVC {
    
    func rowClick(text: String) {
        
        switch text {
            
        case "DrawRect":
            let vc = DrawRectVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "View mask":
            let vc = MaskVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "CAGradientLayer":
            let vc = CAGradientLayerVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "CAShapeLayer":
            let vc = CAShapeLayerVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "CoreGraphics":
            let vc = CoreGraphicsVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "CoreAnimation":
            let vc = CoreAnimationVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
            
        }
        
    }
    
}
