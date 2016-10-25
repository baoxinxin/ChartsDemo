//
//  BarChartViewController.swift
//  ChartsDemo
//
//  Created by ZLY on 16/10/13.
//  Copyright © 2016年 BX. All rights reserved.
//

//柱形图

import UIKit
import Charts
import SnapKit

class BarChartViewController: UIViewController, ChartViewDelegate{
    
    var barChartView: BarChartView!
    var data: BarChartData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barChartView = BarChartView()
        self.view.addSubview(self.barChartView)
        self.barChartView.delegate = self
        self.barChartView.backgroundColor = UIColor(colorLiteralRed: 233/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        self.barChartView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.greaterThanOrEqualTo(CGSize(width: self.view.bounds.size.width-20, height: 300))
        }
        
        //基本样式
        self.barChartView.noDataText = "暂无数据"  //没有数据时的文字提示
        self.barChartView.drawBarShadowEnabled = true //数据显示在柱形的上面还是下面
        self.barChartView.drawHighlightArrowEnabled = false //点击柱形图是否有箭头
        self.barChartView.drawBarShadowEnabled = false  //是否绘制柱形图的阴影背景
        
        //barChartView的交互设置
        self.barChartView.scaleYEnabled = false //取消Y轴缩放
        self.barChartView.doubleTapToZoomEnabled = false  //取消双击缩放
        self.barChartView.dragEnabled = true //启动拖拽图表
        self.barChartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        self.barChartView.dragDecelerationFrictionCoef = 0.9 //拖拽后惯性效果的摩擦系数(0~1)，数值越小惯性越不明显
        
        //设置barChartView的X轴样式
        //首先需要先获取barChartView的X轴
        let xAxis = self.barChartView.xAxis
        xAxis.axisLineWidth = 1 //设置X轴线宽
        xAxis.labelPosition = .Bottom  //X轴的显示位置，默认显示在上面的
        xAxis.drawGridLinesEnabled = false //不绘制网格线
        xAxis.spaceBetweenLabels = 4 //设置label间隔，若设置为1，如果能全部显示，则每个助兴下面都会显示label
        xAxis.labelTextColor = UIColor.brownColor()
        
        //设置barChartView的Y轴样式
        //barChartView默认样式中会绘制左右两侧的Y轴，先隐藏右侧的
        self.barChartView.rightAxis.enabled = false //不绘制右边轴
        //设置左侧Y轴的样式
        let leftAxis = self.barChartView.leftAxis
        leftAxis.forceLabelsEnabled = false //不强制绘制指定数据的label
        leftAxis.showOnlyMinMaxEnabled = false //是否只显示最大值和最小值
        leftAxis.axisMinValue = 0 //设置Y轴的最小值
//        leftAxis.startAtZeroEnabled = true //从0开始绘制
        leftAxis.axisMaxValue = 105 //设置Y轴的最大值
        leftAxis.inverted = false //是否将Y轴进行上下翻转
        leftAxis.axisLineWidth = 0.5 //Y轴线宽
        leftAxis.axisLineColor = UIColor.blackColor()
        
        //labelCount属性设置Y轴要均分的数量
        //设置labelCount的值不一定就是Y轴要均分的数量;还要取决于forceLabelsEnabled属性，如果为true，可能为不均分的
        leftAxis.labelCount = 5
        leftAxis.labelPosition = .OutsideChart //label位置
        leftAxis.labelTextColor = UIColor.brownColor()
        leftAxis.labelFont = UIFont.systemFontOfSize(10)
        //Y轴上标签显示数字的格式
        leftAxis.valueFormatter = NSNumberFormatter()//自定义格式
        leftAxis.valueFormatter?.positiveSuffix = "$" //数字后缀单位
        //设置Y轴上网格线的格式
        leftAxis.gridLineDashLengths = [3, 3]; //设置虚线样式的网格线
        leftAxis.gridColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        leftAxis.gridAntialiasEnabled = true  //开启抗锯齿
        
        //在Y轴上添加限制线
        let limitLine = ChartLimitLine(limit: 80, label: "限制线")
        limitLine.lineWidth = 2
        limitLine.lineDashLengths = [5, 5] //虚线样式
        limitLine.labelPosition = .RightTop //位置
        leftAxis.addLimitLine(limitLine)
        leftAxis.drawLimitLinesBehindDataEnabled = true //设置限制线绘制在柱形图的后面
        
        //通过legend获取到图例对象，然后把它隐藏起来
        self.barChartView.legend.enabled = false //不显示图例说明
        self.barChartView.descriptionText = "" //不显示，就设为空字符串
        
        //为barChartView提供数据
        //为barChartView提供数据是通过其data属性提供的
        
        
        self.data = self.setData()
        //为柱形图提供数据
        self.barChartView.data = self.data
        //设置动画效果，可以设置X轴和Y轴的动画效果
        self.barChartView.animate(yAxisDuration: 1)
        
        
    }
    
    func setData() -> BarChartData {
        
        let xVals_count = 12 //X轴上要显示多少条数据
        let maxYVal: UInt32 = 100 //Y轴的最大值
        //X轴上面需要显示的数据
        var xVals : [NSObject] = []
        for i in 0..<xVals_count {
            xVals.append(NSString(format: "%d月", i+1))
        }
        //对应Y轴上面需要显示的数据
        var yVals = Array<ChartDataEntry>()
        for i in 0..<xVals_count {
            let mult = maxYVal + 1
            let val = Double(arc4random_uniform(mult))
            let entry = BarChartDataEntry(value: val, xIndex: i)
            yVals.append(entry)
        }
        
        //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
        let set1 = BarChartDataSet()
        set1.yVals = yVals;
        set1.barSpace = 0.2//柱形之间的间隙占整个柱形（柱形+间隙）的比例
        set1.highlightEnabled = false //点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        set1.drawValuesEnabled = true //是否在柱形图上面显示数值
        set1.setColors(ChartColorTemplates.material(), alpha: 1)   //设置柱形图颜色
        //将BarChartDataSet对象放入数组中
        var dataSets : [BarChartDataSet] = []
        dataSets.append(set1)
        
        //创建BarChartData对象，此对象就是barChartView需要最终数据对象
        let data = BarChartData(xVals: xVals, dataSets: dataSets)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10))
        data.setValueTextColor(UIColor.orangeColor())
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle  //自定义数据显示格式
        formatter.positiveFormat = "#0.0"
        data.setValueFormatter(formatter)
        return data
    }
    
    //MARK: - barChartView代理方法
    //点击选中柱形图时的代理方法
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("chartValuesSelected-%g", entry.value)
    }
    
    //没有选中柱形图时的代理方法
    func chartValueNothingSelected(chartView: ChartViewBase) {
        print("没有选中柱形图的代理方法")
    }//当选中一个柱形图后，在空白处双击，就可以取消选择，此时回到此方法
    
    //捏合放大或缩小柱形图时的代理方法
    func chartScaled(chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        print("捏合放大或缩小柱形图时")
    }
    
    //拖拽图表时的代理方法
    func chartTranslated(chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        print("拖拽图表时的代理方法")
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
