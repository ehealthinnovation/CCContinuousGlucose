//
//  ChartViewController.swift
//  CCContinuousGlucose
//
//  Created by Kevin Tallevi on 5/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

// swiftlint:disable function_body_length
// swiftlint:disable syntactic_sugar

import Foundation
import UIKit
import Charts
import CCContinuousGlucose

class ChartViewController: UIViewController, ChartViewDelegate, ContinuousGlucoseMeasurementProtocol {
    @IBOutlet weak var lineChartView: LineChartView!
    private var continuousGlucose: ContinuousGlucose!
    var glucoseMeasurements: Array<ContinuousGlucoseMeasurement> = Array<ContinuousGlucoseMeasurement>()
    var selectedGlucoseMeasurement: ContinuousGlucoseMeasurement!
    var glucoseMeasurementCounter: Int = 0
    public var hyperAlertLine: Double!
    public var hypoAlertLine: Double!
    public var patientLowLine: Double!
    public var patientHighLine: Double!


    override func viewDidLoad() {
        super.viewDidLoad()

        let customBackButton = UIBarButtonItem(title: "End Session", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.customBackMethod(sender:)))

        self.navigationItem.leftBarButtonItem = customBackButton

        glucoseMeasurementCounter = 0
        setupLineChart()
        ContinuousGlucose.sharedInstance().continuousGlucoseMeasurementDelegate = self
        ContinuousGlucose.sharedInstance().startSession()
    }

    // @objc is so we can use #selector()
    @objc func customBackMethod(sender: UIBarButtonItem) {
        ContinuousGlucose.sharedInstance().stopSession()

        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {

    }

    func setupLineChart() {
        self.lineChartView.delegate = self
        self.lineChartView.chartDescription?.enabled = false
        self.lineChartView.dragEnabled = true
        self.lineChartView.setScaleEnabled(true)
        self.lineChartView.pinchZoomEnabled = true
        self.lineChartView.drawGridBackgroundEnabled = false

        let llXAxis = ChartLimitLine(limit: 10.0, label: "Index 10")
        llXAxis.lineWidth = 4.0
        llXAxis.lineDashLengths = [10.0, 10.0, 0.0]
        llXAxis.labelPosition = ChartLimitLine.LabelPosition.rightBottom
        llXAxis.valueFont = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.light)

        lineChartView.xAxis.gridLineDashLengths = [10.0, 10.0]
        lineChartView.xAxis.gridLineDashPhase = 0.0

        let hyperAlertLineLimit = ChartLimitLine(limit: self.hyperAlertLine, label: "Hyper Alert")
        hyperAlertLineLimit.lineColor = UIColor.red
        hyperAlertLineLimit.lineWidth = 4.0
        hyperAlertLineLimit.lineDashLengths = [5.0, 5.0]
        hyperAlertLineLimit.labelPosition = ChartLimitLine.LabelPosition.rightTop
        hyperAlertLineLimit.valueFont = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.light)

        let hypoAlertLineLimit = ChartLimitLine(limit: self.hypoAlertLine, label: "Hypo Alert")
        hypoAlertLineLimit.lineColor = UIColor.red
        hypoAlertLineLimit.lineWidth = 4.0
        hypoAlertLineLimit.lineDashLengths = [5.0, 5.0]
        hypoAlertLineLimit.labelPosition = ChartLimitLine.LabelPosition.rightBottom
        hypoAlertLineLimit.valueFont = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.light)

        let patientHighLineLimit = ChartLimitLine(limit: self.patientHighLine, label: "Patient High Alert")
        patientHighLineLimit.lineColor = UIColor.green
        patientHighLineLimit.lineWidth = 4.0
        patientHighLineLimit.lineDashLengths = [5.0, 5.0]
        patientHighLineLimit.labelPosition = ChartLimitLine.LabelPosition.rightBottom
        patientHighLineLimit.valueFont = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.light)

        let patientLowLineLimit = ChartLimitLine(limit: 100.0, label: "Patient Low Alert")
        patientLowLineLimit.lineColor = UIColor.green
        patientLowLineLimit.lineWidth = 4.0
        patientLowLineLimit.lineDashLengths = [5.0, 5.0]
        patientLowLineLimit.labelPosition = ChartLimitLine.LabelPosition.rightTop
        patientLowLineLimit.valueFont = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.light)

        let leftAxis: YAxis = lineChartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(hyperAlertLineLimit)
        leftAxis.addLimitLine(hypoAlertLineLimit)
        leftAxis.addLimitLine(patientHighLineLimit)
        leftAxis.addLimitLine(patientLowLineLimit)
        leftAxis.axisMaximum = self.hyperAlertLine + 100.0
        leftAxis.axisMinimum = 0.0
        leftAxis.gridLineDashLengths = [5.0, 5.0]
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawLimitLinesBehindDataEnabled = true

        lineChartView.rightAxis.enabled = false
        lineChartView.animate(xAxisDuration: 2.5)
    }

    func updateLineChart() {
        var values = [Any]()
        for i in 0..<glucoseMeasurements.count {
            let val: Double = Double(glucoseMeasurements[i].glucoseConcentration)
            values.append(ChartDataEntry(x:Double(i), y: val))
        }

        var dataSet: LineChartDataSet? = nil
        guard lineChartView.data?.dataSetCount != nil else {
            dataSet = LineChartDataSet(values: values as? [ChartDataEntry], label: "Glucose")
            dataSet?.drawIconsEnabled = false
            dataSet?.lineDashLengths = [5.0, 2.5]
            dataSet?.highlightLineDashLengths = [5.0, 2.5]
            dataSet?.lineWidth = 1.0
            dataSet?.circleRadius = 3.0
            dataSet?.drawCircleHoleEnabled = false
            dataSet?.valueFont = UIFont.systemFont(ofSize: CGFloat(9.0))
            dataSet?.formLineDashLengths = [5.0, 2.5]
            dataSet?.formLineWidth = 1.0
            dataSet?.formSize = 15.0
            dataSet?.drawFilledEnabled = false
            var dataSets = [Any]()
            dataSets.append(dataSet!)
            let data = LineChartData(dataSets: dataSets as? [IChartDataSet])
            lineChartView.data = data

            return
        }

        dataSet = (lineChartView.data?.dataSets[0] as? LineChartDataSet)
        dataSet?.values = values as! [ChartDataEntry]
        lineChartView.data?.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMeasurementDetails" {
            let MeasurementDetailsVC = (segue.destination as! MeasurementDetailsViewController)
            MeasurementDetailsVC.glucoseMeasurement = selectedGlucoseMeasurement
        }
    }

    // MARK
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let glucoseMeasurement = glucoseMeasurements[Int(entry.x)]

        let measurementDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "measurementDetailsView") as! MeasurementDetailsViewController
        measurementDetailsVC.glucoseMeasurement = glucoseMeasurement

        selectedGlucoseMeasurement = glucoseMeasurement

        performSegue(withIdentifier: "segueToMeasurementDetails", sender: self)
    }

    //MARK
    func continuousGlucoseMeasurement(measurement: ContinuousGlucoseMeasurement) {
        glucoseMeasurements.append(measurement)
        updateLineChart()
    }
}
