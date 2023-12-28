//
//  SideMenuVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/25.
//

import UIKit
import SideMenu

class SideMenuVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("Test", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindActions()
    }
    
}

private extension SideMenuVC {
    
    func config() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.dd.named("ic_coupon_interest"), style: .plain, target: self, action: #selector(rightClick))
        
    }
    
    func setupViews() {
        
        testBtn.add(to: view).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.rightClick1()
        }).disposed(by: disposeBag)
        
    }
    
}

private extension SideMenuVC {
    
    func testClick() {
        
        let menu = SideMenuNavigationController(rootViewController: MenuSectionVC())
        menu.isNavigationBarHidden = true
        
        SideMenuManager.default.leftMenuNavigationController = menu
        
        /**
         // 开启通过边缘滑动打开侧栏菜单的功能
                 SideMenuManager.default.menuAddPanGestureToPresent(toView:
                     self.navigationController!.navigationBar)
                 SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView:
                     self.navigationController!.view)
         */
        
        /// 开启通过边缘滑动打开侧边栏菜单的功能
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // 阻止状态栏背景变黑
//        SideMenuManager.default.menuFadeStatusBar = false
        
        SideMenuManager.default.menuPresentMode = .viewSlideOut
        
        self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true,
                             completion: nil)
        
    }
    
    func sideMenu() {
        
    }
    
    @objc func rightClick() {
        
        SideMenuManager.default.leftMenuNavigationController = SideMenuNavigationController(rootViewController: MenuSectionVC())
        
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        
            // [.menuSlideIn, .viewSlideOut, .viewSlideOutMenuIn, .menuDissolveIn]
        
        var settings = SideMenuSettings()
        
        let presentationStyle = SideMenuPresentationStyle.viewSlideOutMenuIn
//        presentationStyle.backgroundColor = UIColor.red
//        presentationStyle.menuStartAlpha = 0.7
        presentationStyle.menuOnTop = true
        
        settings.presentationStyle = presentationStyle
        settings.menuWidth = 137.auto
        settings.statusBarEndAlpha = 0
        settings.presentDuration = 1
        
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        
        self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true)
        
    }
    
    @objc func rightClick1() {
        
        SideMenuManager.default.leftMenuNavigationController = SideMenuNavigationController(rootViewController: MenuSectionVC())
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        
        let style = SideMenuPushStyle.default
    
        
        self.navigationController?.pushViewController(SideMenuManager.default.leftMenuNavigationController!, animated: true)
        
    }
    
}

