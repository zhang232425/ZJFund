//
//  ZJInitVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/3/4.
//

import UIKit
import RxSwift
import RxCocoa

// https://juejin.cn/post/7332647780207198245
// https://juejin.cn/post/7332383052561842213

class ZJInitVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("开始测试", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }

}

private extension ZJInitVC {
    
    func setupViews() {
        
        testBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(100)
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.test1()
        }).disposed(by: disposeBag)
        
    }
    
    
}

private extension ZJInitVC {
    
    func test1() {
        
        let roctket1 = RocketConfiguration(liquidOxygenMass: 12.0, nominalBurnTime: 137, propellantMass: 37.5)
        let roctket2 = RocketConfiguration(liquidOxygenMass: 12.2, propellantMass: 37.1)
        
        /**
         let currentWeather = Weather()
         currentWeather.temperatureCelsius
         currentWeather.windSpeedKilometersPerHour
         */
        
        let currentWeather = Weather(temperatureFahrenheit: 87, windSpeedMilesPerHour: 2)
        print(" ===== \(currentWeather.temperatureCelsius)")
        print(" ===== \(currentWeather.windSpeedKilometersPerHour)")
        
        
        
    }
    
}

/// --------------- 定义相关的结构体、枚举、类 -------------------

/*
struct RocketConfiguration {

    /// 存储属性
    let name: String = "Athena 9 Heavy"
    let numberOfFirstStageCores: Int = 3
    let numberOfSecondStageCores: Int = 1

//    var numberOfStageReuseLandingLegs: Int? = nil
    let numberOfStageReuseLandingLegs: Int? = nil
    
}
*/

struct RocketConfiguration {
    
    let liquidOxygenMass: Double
    let nominalBurnTime: Int
    let propellantMass: Double
    
}

extension RocketConfiguration {
    
    init(liquidOxygenMass: Double, propellantMass: Double) {
        self.liquidOxygenMass = liquidOxygenMass
        self.propellantMass = propellantMass
        self.nominalBurnTime = 180
    }
    
}

/**
 struct Weather {
     let temperatureCelsius: Double
     let windSpeedKilometersPerHour: Double
 }
 */

struct Weather {
    
    let temperatureCelsius: Double
    let windSpeedKilometersPerHour: Double

    init(temperatureFahrenheit: Double = 72, windSpeedMilesPerHour: Double = 5) {
      self.temperatureCelsius = (temperatureFahrenheit - 32) / 1.8
      self.windSpeedKilometersPerHour = windSpeedMilesPerHour * 1.609344
    }
    
}
