//
//  HanggeInfographicsVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/27.
//

import UIKit
import AAInfographics

/** 图形绘制
 Core Graphics
 
 */

class HanggeInfographicsVC: BaseVC {
    
    private lazy var chartView = AAChartView()
    
    private lazy var chartModel = AAChartModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
    }
    
}

private extension HanggeInfographicsVC {
    
    func config() {
        
        self.navigationItem.title = "Hangge-Infographics"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.dd.named("ic_coupon_interest"), style: .plain, target: self, action: #selector(rightClick))
        
    }
    
    func setupViews() {
        
        chartView.add(to: view).snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(237)
        }
        
    }
    
    @objc func rightClick() {
        
        self.chart17()
        
    }
    
}

private extension HanggeInfographicsVC {
    
    func chart1() {
        
        chartModel
            .chartType(.column)
            .title("深圳天气变化")
            .titleStyle(AAStyle(color: "#0000FF", fontSize: 18, weight: .bold))
            .subtitle("2023年12月27日")
            .subtitleStyle(AAStyle(color: "#FF0000"))
            .backgroundColor("#FFFF00") // 图表的背景
//            .margin(top: 30, right: 30, bottom: 100, left: 60)
            .inverted(false)
            .yAxisTitle("摄氏度")
            .xAxisTitle("月份")
            .legendEnabled(true)
            .tooltipValueSuffix("摄氏度")
            .dataLabelsEnabled(true)
            .categories(["一月", "二月", "三月", "四月", "五月", "六月"])
            .colorsTheme(["#FE117C", "#FFC069", "#06CAF4"])
            .series([
                AASeriesElement()
                    .name("深圳")
                    .data([7.0, 6.9, 9.5, 29.2, 18.2, 11.2])
                    .dataLabels(
                        AADataLabels()
                            .enabled(true)
//                            .style(AAStyle(color: "#0000FF", fontSize: 16, weight: .regular))
                            .color("#F000FF")
//                            .x(-10)
//                            .y(10)
//                            .inside(true)
                    ),
                AASeriesElement()
                    .name("长沙")
                    .data([0.2, 0.8, 5.7, 21.3, 17.0, 10.0]),
                AASeriesElement()
                    .name("怀化")
                    .data([0.9, 0.6, 3.5, 25.7, 13.5, 7])
            ])
        
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// x轴和y轴的样式
    func chart2() {
        
        chartModel
            .chartType(.column)
            .title("深圳天气变化")
            .subtitle("2023年12月27日")
            .inverted(false)
            .yAxisTitle("摄氏度")
            .xAxisTitle("月份")
            .legendEnabled(true)
            .tooltipValueSuffix("摄氏度")
            .dataLabelsEnabled(true)
            .categories(["一月", "二月", "三月", "四月", "五月", "六月"])
            .colorsTheme(["#FE117C", "#FFC069"])
            .series([
                AASeriesElement()
                    .name("深圳")
                    .data([7.0, 6.9, 9.5, 29.2, 18.2, 11.2]),
                AASeriesElement()
                    .name("长沙")
                    .data([0.2, 0.8, 5.7, 21.3, 17.0, 10.0])
            ])
        
        /**
         .xAxisReversed(false) //x轴是否翻转：否
             .yAxisReversed(false) //y轴是否翻转：否
             .xAxisVisible(true) //x轴是否显示：是
             .yAxisVisible(true) //y轴是否显示：是
             .xAxisLabelsEnabled(true) //x轴是否显示数据：是
             .yAxisLabelsEnabled(true) //y轴是否显示数据：是
             .xAxisGridLineWidth(3) //x轴网格线的宽度
             .yAxisGridLineWidth(6) //y轴网格线的宽度
             .yAxisTitle("摄氏度") //y轴标题
             .axisColor("#0000FF") //x轴和y轴文字颜色
         */
        
        chartModel
            .xAxisReversed(false) // x轴是否翻转
            .yAxisReversed(false) // y轴是否翻转
            .xAxisVisible(true)  // 是否显示x轴
            .yAxisVisible(true)  // 是否显示y轴
            .xAxisLabelsEnabled(true) // x轴是否显示数据
            .yAxisLabelsEnabled(true)
//            .xAxisGridLineWidth(0)
//            .yAxisGridLineWidth(0)
            .yAxisTitle("温度")
            .xAxisTitle("时间")
            .xAxisLabelsStyle(AAStyle(color: "#0000FF"))
            .yAxisLabelsStyle(AAStyle(color: "#0000FF"))
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 图例相关样式设置
    func chart3() {
        
        chartModel
            .chartType(.column)
            .categories(["一月", "二月", "三月", "四月", "五月", "六月"])
            .colorsTheme([AAGradientColor.oceanBlue,
                          AAGradientColor.sanguine,
                          AAGradientColor.lusciousLime])
            .dataLabelsEnabled(true)
            .legendEnabled(true)
            .zoomType(.x)
            .series([
                AASeriesElement()
                    .name("深圳")
                    .data([7.0, 6.9, 9.5, 29.2, 18.2, 11.2]),
                AASeriesElement()
                    .name("长沙")
                    .data([0.2, 0.8, 5.7, 21.3, 17.0, 10.0])
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 所有的内置渐变颜色
    func chart4() {
        
        /**
         // 初始化图表模型
                 let chartModel = AAChartModel()
                     .chartType(.bar)//图表类型
                     .title("城市天气变化")//图表主标题
                     .inverted(false)//是否翻转图形
                     .legendEnabled(true)//是否启用图表的图例(图表底部的可点击的小圆点)
                     .tooltipValueSuffix("摄氏度")//浮动提示框单位后缀
                     .categories(gradientColorNamesArr)
                     .colorsTheme(gradientColorArr as [Any])//渐变颜色数组
                     .series([
                         AASeriesElement()
                             .name("2018")
                             .data(Array(0..<gradientColorArr.count).map{ _ in 75 })
                             .colorByPoint(true)
                             .toDic()!])
                  
                 // 图表视图对象调用图表模型对象,绘制最终图形
                 aaChartView.aa_drawChartWithChartModel(chartModel)
         */
        
        let gradientColorNamesArr = [
            "oceanBlue",
            "sanguine",
            "lusciousLime",
            "purpleLake",
            "freshPapaya",
            "ultramarine",
            "pinkSugar",
            "lemonDrizzle",
            "victoriaPurple",
            "springGreens",
            "mysticMauve",
            "reflexSilver",
            "newLeaf",
            "cottonCandy",
            "pixieDust",
            "fizzyPeach",
            "sweetDream",
            "firebrick",
            "wroughtIron",
            "deepSea",
            "coastalBreeze",
            "eveningDelight",
            ]
        
        let gradientColorArr = [
            AAGradientColor.oceanBlue,
            AAGradientColor.sanguine,
            AAGradientColor.lusciousLime,
            AAGradientColor.purpleLake,
            AAGradientColor.freshPapaya,
            AAGradientColor.ultramarine,
            AAGradientColor.pinkSugar,
            AAGradientColor.lemonDrizzle,
            AAGradientColor.victoriaPurple,
            AAGradientColor.springGreens,
            AAGradientColor.mysticMauve,
            AAGradientColor.reflexSilver,
            AAGradientColor.newLeaf,
            AAGradientColor.cottonCandy,
            AAGradientColor.pixieDust,
            AAGradientColor.fizzyPeach,
            AAGradientColor.sweetDream,
            AAGradientColor.firebrick,
            AAGradientColor.wroughtIron,
            AAGradientColor.deepSea,
            AAGradientColor.coastalBreeze,
            AAGradientColor.eveningDelight,
            ]
        
        chartModel
            .chartType(.bar)
            .title("城市天气变化")
            .inverted(true)
            .legendEnabled(true)
            .tooltipValueSuffix("摄氏度")
            .categories(gradientColorNamesArr)
            .colorsTheme(gradientColorArr)
            .series([
                AASeriesElement()
                    .name("2018")
                    .data(Array(0..<gradientColorArr.count).map{ _ in 75 })
                    .colorByPoint(true)
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
        
    }
    
    /// 使用自定义渐变色
    func chart5() {
        
        /**
         // 初始化图表模型
                 let chartModel = AAChartModel()
                     .chartType(.column)//图表类型
                     .title("城市天气变化")//图表主标题
                     .inverted(false)//是否翻转图形
                     .legendEnabled(true)//是否启用图表的图例(图表底部的可点击的小圆点)
                     .tooltipValueSuffix("摄氏度")//浮动提示框单位后缀
                     .categories(["渐变1", "渐变3", "渐变2"])
                     .colorsTheme([
                         GradientColorDicMaker
                             .configureGradientColorDictionary(startColor: "000000",
                                                               endColor: "FFFFFF"),
                         GradientColorDicMaker
                             .configureGradientColorDictionary(startColor: "FF00FF",
                                                               endColor: "FFFFFF"),
                         GradientColorDicMaker
                             .configureGradientColorDictionary(startColor: "FF0000",
                                                               endColor: "FFFF00")
                         ])//渐变颜色数组
                     .series([
                         AASeriesElement()
                             .name("2018")
                             .data(Array(0..<3).map{ _ in 75 })
                             .colorByPoint(true)
                             .toDic()!])
                  
                 // 图表视图对象调用图表模型对象,绘制最终图形
                 aaChartView.aa_drawChartWithChartModel(chartModel)
         */
        
        chartModel
            .chartType(.column)
            .title("城市天气变化")
            .inverted(false) // 是否旋转图形
            .legendEnabled(true)
            .tooltipValueSuffix("@")
            .categories(["渐变1", "渐变2", "渐变3"])
            .colorsTheme([
                AAGradientColor.linearGradient(startColor: "#000000", endColor: "#FFFFFF"),
                AAGradientColor.linearGradient(startColor: "#FF00FF", endColor: "#FFFFFF"),
                AAGradientColor.linearGradient(startColor: "#FF0000", endColor: "#FFFF00"),
            ])
            .series([
                AASeriesElement()
                    .name("2018")
                    .data(Array(0..<3).map { _ in 75 })
                    .colorByPoint(true)
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 折线图
    func chart6() {
        
        chartModel
            .chartType(.line)
//            .polar(true)
            .markerSymbol(.square)
            .markerSymbolStyle(.borderBlank)
//            .markerRadius(40)
            .title("城市天气变化")
            .subtitle("2023年12月27日")
            .inverted(false)
            .yAxisTitle("温度")
            .legendEnabled(true)
            .tooltipEnabled(false)
            .tooltipValueSuffix("摄氏度")
            .categories(["一月", "二月", "三月", "四月", "五月", "六月"])
            .colorsTheme(["#fe117c","#ffc069","#06caf4"])//主题颜色数组
            .series([
                AASeriesElement()
                    .name("东京")
                    .lineWidth(3)
                    .dashStyle(.dashDot)
                    .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5]),
                AASeriesElement()
                    .name("纽约")
                    .dashStyle(.dash)
                    .data([0.2, 0.8, 5.7, 11.3, 17.0, 25.0]),
                AASeriesElement()
                    .name("柏林")
                    .dashStyle(.dot)
                    .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0])
                    ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
        
    }
    
    /// 曲线图
    func chart7() {
        
        chartModel
            .chartType(.line)
            .markerRadius(0)
            .title("城市天气变化")
            .subtitle("2023年12月27日")
            .inverted(false)
            .yAxisTitle("温度")
            .dataLabelsEnabled(true)
            .legendEnabled(true)
            .tooltipEnabled(false)
            .tooltipValueSuffix("摄氏度")
            .categories(["一月", "二月", "三月", "四月", "五月", "六月"])
            .colorsTheme(["#fe117c","#ffc069","#06caf4"])//主题颜色数组
            .series([
                AASeriesElement()
                    .name("东京")
                    .lineWidth(3)
                    .step(true)
                    .step("center")
                    .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5]),
                AASeriesElement()
                    .name("纽约")
                    .step(true)
                    .data([0.2, 0.8, 5.7, 11.3, 17.0, 25.0]),
                AASeriesElement()
                    .name("柏林")
                    .step(true)
                    .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0])
                    ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 面积图、填充图、直方折线填充图
    func chart8() {

        chartModel
            .chartType(.areaspline)
            .markerRadius(0)
            .title("城市天气")
            .subtitle("2023年12月27日")
            .inverted(false)
            .yAxisTitle("温度")
            .legendEnabled(true)
            .tooltipValueSuffix("摄氏度")
            .categories(["一月", "二月", "三月", "四月", "五月", "六月"])
            .colorsTheme(["#fe117c","#ffc069","#06caf4"])
            .series([
                AASeriesElement()
                    .name("东京")
//                    .color(<#T##prop: Any##Any#>)
//                    .negativeColor(<#T##prop: Any##Any#>)
                    .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5]),
                AASeriesElement()
                    .name("纽约")
                    .data([0.2, 0.8, 5.7, 11.3, 17.0, 25.0]),
                AASeriesElement()
                    .name("柏林")
                    .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0])
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
    
    }
    
    /// 柱形图
    func chart9() {
        
        chartModel
            .chartType(.column)
            .dataLabelsEnabled(true)
            .title("城市天气")
            .subtitle("2023年12月27日")
            .inverted(false)
            .yAxisTitle("温度")
            .legendEnabled(true)
            .tooltipValueSuffix("度")
            .categories(["一月", "二月", "三月", "四月", "五月", "六月"])
            .colorsTheme(["#fe117c","#ffc069","#06caf4"])//主题颜色数组
            .series([
                AASeriesElement()
                            .name("图例1")
                            .data([-6.4, -5.2, -3.0, 0.2, 2.3, 5.5, 8.4, 8.3, 5.1, 0.9])
                            .threshold(2)
                            .color("#0088FF")
                            .negativeColor("#FF0000")
                ])
        
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 饼图
    func chart10() {
        
        chartModel
            .chartType(.pie)
            .title("编程语言统计")
            .subtitle("2023年12月27日")
            .inverted(false)
            .dataLabelsEnabled(true)
            .series([
                AASeriesElement()
                    .name("使用人数")
                    .innerSize("50%")
                    .borderWidth(3)
                    .allowPointSelect(false)
                    .data([["Java", 67], ["Swift", 333], ["Python", 83], ["OC", 11], ["Go", 30]])
                                    
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 散点图气泡图
    func chart11() {
        
        chartModel
            .chartType(.bubble)
            .markerSymbol(.circle)
            .title("身高体重分布图")
            .titleStyle(AAStyle()
                .color("#FFFFFF")
            )
            .subtitle("2023年12月28日")
            .subtitleStyle(AAStyle()
                .color("#FFFFFF")
            )
//            .axisColor("#ffffff")//轴线颜色
            .xAxisLabelsStyle(AAStyle()
                .color("#FF0000")
            )
            .yAxisTitle("kg")
            .xAxisTitle("cm")
            .backgroundColor("#22324c")
            .dataLabelsEnabled(false)
            .series([
                AASeriesElement()
                    .name("女生")
                    .color("rgba(223, 83, 83, 1)")
                    .data([
                        [161.2, 51.6],
                        [167.5, 59.0],
                        [159.5, 49.2],
                        [157.0, 63.0],
                        [170.0, 59.0],
                        [159.1, 47.6],
                        [166.0, 69.8],
                        [176.2, 66.8],
                        [172.5, 55.2],
                        [170.9, 54.2],
                        [172.9, 62.5],
                        [153.4, 42.0],
                        [147.2, 49.8],
                        [168.2, 49.2],
                        [175.0, 73.2],
                        [157.0, 47.8],
                        [159.5, 50.6],
                        [175.0, 82.5],
                        [166.8, 57.2],
                        [176.5, 87.8],
                        [174.0, 54.5],
                        [173.0, 59.8],
                        [179.9, 67.3],
                        [170.5, 67.8]
                    ]),
                AASeriesElement()
                    .name("男生")
                    .color("rgba(119, 152, 191, 1)")
                    .data([
                        [174.0, 65.6],
                        [175.3, 71.8],
                        [193.5, 80.7],
                        [186.5, 72.6],
                        [181.5, 74.8],
                        [184.0, 86.4],
                        [184.5, 78.4],
                        [175.0, 62.0],
                        [180.0, 76.6],
                        [177.8, 83.6],
                        [192.0, 90.0],
                        [176.0, 74.6],
                        [184.0, 79.6],
                        [192.7, 93.8],
                        [171.5, 70.0],
                        [173.0, 72.4],
                        [176.0, 78.8],
                        [180.5, 77.8],
                        [172.7, 66.2],
                        [176.0, 86.4],
                        [178.0, 89.6],
                        [180.3, 82.8],
                        [180.3, 76.4],
                        [164.5, 63.2]
                    ])
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
    
    }
    
    /// 范围图
    func chart12() {
        
        /***
         arearange：折线区域图
         areasplinerange：曲线范围题
         */
        
        //1.折线范围图
        chartModel
            .chartType(.columnrange)
            .inverted(true)
            .title("折线区域范围图")
            .dataLabelsEnabled(true)
            .markerRadius(0)
            .categories(["1号", "2号", "3号", "4号", "5号", "6号", "7号", "8号", "9号", "10号", "11号", "12号"])
            .series([
                AASeriesElement()
                    .name("温度范围")
                    .color(AAGradientColor.linearGradient(startColor: "#8A2BE2", endColor: "#1E90FF"))
                    .data([
                        [-9.7,  9.4],
                        [-8.7,  6.5],
                        [-3.5,  9.4],
                        [-1.4, 19.9],
                        [0.0,  22.6],
                        [2.9,  29.5],
                        [9.2,  30.7],
                        [7.3,  26.5],
                        [4.4,  18.0],
                        [-3.1, 11.4],
                        [-5.2, 10.4],
                        [-13.5, 9.8]
                    ])
            ])
            
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 箱线图
    func chart13() {
        
        chartModel
            .chartType(.boxplot)
            .title("箱形图")
            .legendEnabled(true)
            .yAxisVisible(true)
            .series([
                AASeriesElement()
                    .name("Observed Data")
                    .color("#ef476f")
                    .fillColor("#04d69f")
                    .data([
                        [760, 801, 848, 895, 965],
                        [733, 853, 939, 980, 1080],
                        [714, 762, 817, 870, 918],
                        [724, 802, 806, 871, 950],
                        [834, 836, 864, 882, 910]
                    ])
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 瀑布图
    func chart14() {
        
        /**
         ["upColor":"#9b43b4",
                              "color": "#ef476f",
                              "name": "资产变动情况",
                              "borderWidth":0,
                              "data": [
                                 [
                                     "name": "启动资金",
                                     "y": 120000
                                 ], [
                                     "name": "产品收入",
                                     "y": 569000
                                 ], [
                                     "name": "服务收入",
                                     "y": 231000
                                 ], [
                                     "name": "正平衡",
                                     "isIntermediateSum": true,
                                     "color": "#ffd066"
                                 ], [
                                     "name": "固定成本",
                                     "y": -342000
                                 ], [
                                     "name": "可变成本",
                                     "y": -233000
                                 ], [
                                     "name": "余额",
                                     "isSum": true,
                                     "color": "#04d69f"
                                 ]],
                              ]]
         */
        
        chartModel
            .chartType(.waterfall)
            .title("瀑布图")
            .legendEnabled(true)
            .yAxisVisible(true)
            .series([
                AASeriesElement()
                    .name("数据")
                    .data([
                        [
                            "upColor": "#9b43b3",
                            "color": "#ef476f",
                            "name": "资产变动情况",
                            "borderWidth": 0,
                            "data": [
                                        ["name": "启动资金", "y": "120000"],
                                        ["name": "产品收入", "y": "569000"],
                                        ["name": "服务收入", "y": "231000"],
                                        ["name": "正平衡", "isIntermediateSum": true, "color": "#ffd066"],
                                        ["name": "固定成本", "y": "-342000"],
                                        ["name": "可变成本", "y": "-233000"],
                                        ["name": "余额", "isSum": true, "color": "#04d69f"]
                                    ]
                        ]
                    ])
            ])
        
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 金子塔图 漏斗图
    func chart15() {
        
        chartModel
            .chartType(.funnel)
            .title("年龄分布")
            .yAxisVisible(true)
            .series([
                AASeriesElement()
                    .name("人数")
                    .data([
                        ["0 ~ 10岁", 20000],
                        ["10 ~ 30岁", 12379],
                        ["30 ~ 50岁", 4286],
                        ["50 ~ 70岁", 3552],
                        ["> 70岁", 1654]
                    ])
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 混合图表
    func chart16() {
        
        /*
        chartModel
            .title("气温趋势图")
            .dataLabelsEnabled(false)
            .categories(["1号", "2号", "3号", "4号", "5号", "6号", "7号", "8号", "9号", "10号", "11号", "12号"])
            .series([
                AASeriesElement()
                    .name("温度范围")
                    .type(.areasplinerange)
                    .color("#1E90FF")
                    .lineWidth(0)
                    .fillOpacity(0.3)
                    .zIndex(0)
                    .data([
                        [-9.7,  9.4], [-8.7,  6.5], [-3.5,  9.4],
                        [-1.4, 19.9], [0.0,  22.6], [2.9,  29.5],
                        [9.2,  30.7], [7.3,  26.5], [4.4,  18.0],
                        [-3.1, 11.4], [-5.2, 10.4], [-13.5, 9.8]
                    ]),
                AASeriesElement()
                    .name("平均温度")
                    .type(.line)
                    .color("#FFFFFF")
                    .zIndex(1)
                    .marker(AAMarker()
                        .lineColor("#000000")
                        .lineWidth(2)
                        .fillColor("#1E90FF"))
                    .data([
                        1, -2, 3, 8, 11, 17, 20, 16, 11, 5, 2.5, -2
                    ])
                
            ])
         
         */
        
        /**
         AASeriesElement()
                                 .name("净收入")
                                 .type(.column)
                                 .color("#fe117c")
                                 .data([400,728, 999, 456, 567, 666])
                                 .zIndex(0)
                                 .toDic()!,
                             AASeriesElement()
                                 .name("营业额")
                                 .type(.line)
                                 .data([567,899, 1233, 548, 777, 890])
                                 .zIndex(1)
                                 .marker([
                                     "fillColor":"#1E90FF" ,
                                     "lineWidth": 2,
                                     "lineColor":"white"
                                     ])
                                 .toDic()!
         */
        
        chartModel
            .title("收入明细")
            .dataLabelsEnabled(false)
            .categories(["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"])
            .series([
                AASeriesElement()
                    .name("支出")
                    .type(.column)
                    .color("#FE117C")
                    .zIndex(0)
                    .data([1200, 2000, 3000, 2500, 2300, 3000, 1300, 1200, 2000, 3100, 2700, 1700]),
                AASeriesElement()
                    .name("收入")
                    .type(.line)
                    .data([2200, 2500, 3500, 3800, 2900, 3600, 2300, 2200, 2100, 3100, 7700, 2700])
                    .zIndex(1)
                    .marker(AAMarker()
                        .fillColor("#1E90FF")
                        .lineWidth(2)
                        .lineColor("white"))
            ])
    
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    /// 动画效果
    func chart17() {
        
        chartModel
            .chartType(.column)
            .title("城市天气")
            .categories(["一月", "二月", "三月", "四月", "五月", "六月"])
            .colorsTheme(["#fe117c","#ffc069"])
            .animationType(.easeOutBack)
            .animationDuration(2000)
            .series([
                AASeriesElement()
                    .name("东京")
                    .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5]),
                AASeriesElement()
                    .name("纽约")
                    .data([0.2, 0.8, 5.7, 11.3, 17.0, 22.0])
            ])
        
        chartView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    func chart18() {
        
        let options = setupOptions()
        
//        chartView.aa_drawChartWithChartOptions(options)
        
    }
    
//    func setupOptions() -> NSMutableDictionary {
//
//
//
//    }
    
}
