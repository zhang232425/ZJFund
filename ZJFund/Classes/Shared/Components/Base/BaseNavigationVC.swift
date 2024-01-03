//
//  BaseNavigationVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/27.
//

import UIKit

class BaseNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)

    }

}

/**
 UINavigationBar
 */

private extension BaseNavigationVC {
    
    func config() {
        
        /***
         iOS 13以上使用UINavigationBarAppearance类来设置
         */
        
        self.navigationBar.isTranslucent = false
        
        /// 1、导航栏背景颜色
        let color = UIColor(hexString: "#F6F8FA")
        let titleStyle = [NSAttributedStringKey.foregroundColor: UIColor.black,
                          NSAttributedStringKey.font: UIFont.medium16]
        if #available(iOS 15.0, *) {
            let apperance = UINavigationBarAppearance()
            apperance.backgroundColor = color
            apperance.titleTextAttributes = titleStyle
            apperance.shadowColor = nil
            self.navigationBar.standardAppearance = apperance
            self.navigationBar.scrollEdgeAppearance = apperance
        } else {
            self.navigationBar.barTintColor = color
            self.navigationBar.titleTextAttributes = titleStyle
        }
        
        /// 导航栏控件颜色
        self.navigationBar.tintColor = UIColor.red
        
    }
    
}
