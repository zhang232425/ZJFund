//
//  HanggeExampleVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/11.
//

import UIKit

/** MVC架构
 Model - View - Controller 三层架构
 1）
 Model：数据层。负责数据的读写，保存App状态等
 View：显示层。显示页面，用户交互，反馈用户行为
 Controller：业务逻辑层。负责业务逻辑、事件响应、数据加工等
 2）
 通常情况下，Model与View不进行通信，而是由Controller层进行协调
 3)
 优点：分工明确，数据，页面，逻辑分层明确，每一层相对独立
 4）
 缺点：
 Controller代码臃肿
 */

/** MVVM架构
 Model - View - ViewModel：MVC架构的升级
 将Controller中的业务逻辑抽离到ViewModel里面，减轻Controller的负担
 View|Controller - ViewModel - Model
 Model与View|Controller之间不进行通信，由ViewModel层协调
 */


class HanggeExampleVC: BaseVC {
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
