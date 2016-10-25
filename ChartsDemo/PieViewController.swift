//
//  PieViewController.swift
//  ChartsDemo
//
//  Created by ZLY on 16/10/13.
//  Copyright © 2016年 BX. All rights reserved.
//

//饼状图

import UIKit
import Charts
import SnapKit

class PieViewController: UIViewController {
    
    var pieChartView : PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pieChartView = PieChartView()
        self.pieChartView.backgroundColor = UIColor.greenColor()
        self.view.addSubview(self.pieChartView)
        self.pieChartView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 300, height: 300))
            make.center.equalTo(self.view)
        }
        
        //设置饼状图外观样式
        //基本样式
        self.pieChartView.setExtraOffsets(left: 30, top: 0, right: 30, bottom: 0) //饼状图距离边缘的间隙
        self.pieChartView.usePercentValuesEnabled = true //是否根据所提供的数据，将显示数据转换为百分比格式
        self.pieChartView.dragDecelerationEnabled = true //拖拽饼状图后是否有惯性效果
        self.pieChartView.drawSliceTextEnabled = true  //是否显示区块文本
        
        //设置饼状图中间的空心样式
        //空心有两个圆组成，一个是hold，一个是transparentCircle,transparentCircle里面是hold，所以饼状图中间的空心也就是一个同心圆
        self.pieChartView.drawHoleEnabled = true //饼状图是否是空心
        self.pieChartView.holeRadiusPercent = 0.5 //空心半径占比
        self.pieChartView.holeColor = UIColor.clearColor() //空心颜色
        self.pieChartView.transparentCircleColor = UIColor(red: 210/255.0, green: 145/255.0, blue: 165/255.0, alpha: 0.3)
        
        //设置饼状图中心的文本
        //当饼状图是空心样式时，可以在饼状图中心添加文本，添加文本有两种方法，一种方法是使用centerText属性添加，这种方法不能设置字体颜色、大小等。另一种方法是使用centerAttributedText属性添加，这种方法添加的富文本，因此就可以对字体进行进一步美化
        if self.pieChartView.isDrawHoleEnabled {
            self.pieChartView.drawCenterTextEnabled = true //是否显示中间文字
            //普通文本
//            self.pieChartView.centerText = "饼状图"
            //富文本
            let centerText = NSMutableAttributedString(string: "饼状图")
            centerText.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(16), NSForegroundColorAttributeName: UIColor.orangeColor()], range: NSRange(location: 0, length: centerText.length))
            self.pieChartView.centerAttributedText = centerText
        }
        
        //设置饼状图描述
        self.pieChartView.descriptionText = "饼状图示例"
        self.pieChartView.descriptionFont = UIFont.systemFontOfSize(10)
        self.pieChartView.descriptionTextColor = UIColor.grayColor()
        
        //设置饼状图图例样式
        self.pieChartView.legend.maxSizePercent = 1 //图例在饼状图中的大小占比，这会影响图例的宽高
        self.pieChartView.legend.formToTextSpace = 5 //文本间隔
        self.pieChartView.legend.font = UIFont.systemFontOfSize(10)
        self.pieChartView.descriptionTextColor = UIColor.grayColor()
        self.pieChartView.legend.position = .AboveChartCenter //图例在饼状图中的位置
        self.pieChartView.legend.form = .Circle //图示样式：方形、线条、圆形
        self.pieChartView.legend.formSize = 12 //图示大小
        
        //为饼状图提供数据
        //为饼状图提供数据，首先需要创建两个数组yVals和xVals，yVals数组存放饼状图每个区块的数据，xVals存放的是每个区块的名称或者描述
        self.pieChartView.data = self.setData()
        
    }
    
    func setData() -> PieChartData {
        let mult: UInt32 = 100
        let count = 5 //饼状图总共有几块组成
        
        //每个区块的数据
        var yVals : [BarChartDataEntry] = []
        for i in 0..<count {
            let randomVal = Double(arc4random_uniform(mult+1))
            let entry = BarChartDataEntry(value: randomVal, xIndex: i)
            yVals.append(entry)
        }
        
        //每个区块的名称和描述
        var xVals: [NSObject] = []
        for i in 0..<count {
            let title = String(format: "part%d", i)
            xVals.append(title)
        }
        
        let dataSet = PieChartDataSet(yVals: yVals, label: "")
        dataSet.drawValuesEnabled = true //是否绘制显示数据
        var colors: [NSUIColor] = []
        colors.appendContentsOf(ChartColorTemplates.vordiplom())
        colors.appendContentsOf(ChartColorTemplates.vordiplom())
        colors.appendContentsOf(ChartColorTemplates.vordiplom())
        colors.appendContentsOf(ChartColorTemplates.joyful())
        colors.appendContentsOf(ChartColorTemplates.colorful())
        colors.appendContentsOf(ChartColorTemplates.liberty())
        colors.appendContentsOf(ChartColorTemplates.pastel())
        colors.append(NSUIColor(red: 51/255.0, green: 181/255.0, blue: 229/255.0, alpha: 1))
        dataSet.colors = colors //区块颜色
        dataSet.sliceSpace = 0 //相邻区块之间的间隔
        dataSet.selectionShift = 8 //选中区块时，放大的半径
        dataSet.xValuePosition = .InsideSlice //名称位置
        dataSet.yValuePosition = .OutsideSlice //数据位置
        //数据与区块之间的用于指示的折线样式
        dataSet.valueLinePart1OffsetPercentage = 0.85 //折线中第一段其实位置相对于区块的偏移量，数值越大，折线距离区块越远
        dataSet.valueLinePart1Length = 0.5 //折线中第一段长度占比
        dataSet.valueLinePart2Length = 0.4 //折线中第二段长度最大占比
        dataSet.valueLineWidth = 1 //折线的粗细
        dataSet.valueLineColor = UIColor.brownColor() //折线颜色
        //每个区块之间如果需要间距，可以通过dataSet对象的sliceSpace属性设置
        dataSet.sliceSpace = 3
        
        //data 
        let data = PieChartData(xVals: xVals, dataSets: [dataSet])
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 0 //小数位数
        formatter.multiplier = NSNumber(float: 1)
        data.setValueFormatter(formatter) //设置显示数据格式
        data.setValueTextColor(UIColor.brownColor())
        data.setValueFont(UIFont.systemFontOfSize(10))
        return data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
