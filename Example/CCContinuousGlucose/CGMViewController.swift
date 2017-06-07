//
//  CGMViewController.swift
//  CCContinuousGlucose
//
//  Created by ktallevi on 04/06/2017.
//  Copyright (c) 2017 ktallevi. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
// swiftlint:disable nesting
// swiftlint:disable line_length
// swiftlint:disable file_length

import Foundation
import UIKit
import CoreBluetooth
import CCContinuousGlucose

class CGMViewController: UITableViewController {
    var selectedMeter: CBPeripheral!
    let cellIdentifier = "CGMCellIdentifier"
    let sectionHeaderHeight: CGFloat = 75
    var continuousGlucoseFeatures: ContinuousGlucoseFeatures!
    var continuousGlucoseStatus: ContinuousGlucoseStatus!
    var glucoseMeasurementCount: UInt16 = 0
    var sessionRunTime: UInt16 = 0
    var continuousGlucoseMeterConnected: Bool = false
    
    enum Section: Int {
        case deviceInfo, session, features, cgmType, cgmSampleLocation, status, timeOffset, numberOfRecords, specificOpsControlPoint, startTime, runTime, count
        
        public func description() -> String {
            switch self {
                case .deviceInfo:
                    return "device information"
                case .features:
                    return "features"
                case .cgmType:
                    return "cgm type"
                case .cgmSampleLocation:
                    return "cgm sample location"
                case .status:
                    return "status"
                case .timeOffset:
                    return "time offset"
                case .numberOfRecords:
                    return "number of records"
                case .specificOpsControlPoint:
                    return "specific ops control point"
                case .startTime:
                    return "start time"
                case .runTime:
                    return "run time"
                case .session:
                    return "session"
                case .count:
                    fatalError("invalid")
            }
        }
        
        public func rowCount() -> Int {
            switch self {
            case .deviceInfo:
                return DeviceInfo.count.rawValue
            case .features:
                return 17
            case .cgmType:
                return 1
            case .cgmSampleLocation:
                return 1
            case .status:
                return 20
            case .timeOffset:
                return 1
            case .numberOfRecords:
                return 1
            case .specificOpsControlPoint:
                return 8
            case .startTime:
                return 1
            case .runTime:
                return 1
            case .session:
                return 1
            case .count:
                fatalError("invalid")
            }
        }
        
        enum DeviceInfo: Int {
            case name, manufacturerName, modelNumber, serialNumber, firmwareVersion, count
        }
        
        enum SpecificOpsControlPoint: Int {
            case getCGMCommunicationInterval, getGlucoseCalibrationValue, getPatientHighAlertLevel, getPatientLowAlertLevel, getHypoAlertLevel, getHyperAlertLevel, getRateOfDecreaseAlertLevel, getRateOfIncreaseAlertLevel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ContinuousGlucose.sharedInstance().peripheral = selectedMeter
        ContinuousGlucose.sharedInstance().continuousGlucoseDelegate = self
        ContinuousGlucose.sharedInstance().connectToContinuousGlucoseMeter(continuousGlucoseMeter: selectedMeter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.refreshTable()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            if self.continuousGlucoseMeterConnected {
               ContinuousGlucose.sharedInstance().disconnectContinuousGlucoseMeter()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
    }
    
    // MARK: table source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = Section(rawValue: section)
        return (sectionType?.rowCount())!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as UITableViewCell
        
        switch indexPath.section {
        case Section.deviceInfo.rawValue:
            switch indexPath.row {
            case Section.DeviceInfo.name.rawValue:
                cell.textLabel!.text = ContinuousGlucose.sharedInstance().name?.description
                cell.detailTextLabel!.text = "name"
            case Section.DeviceInfo.manufacturerName.rawValue:
                cell.textLabel!.text = ContinuousGlucose.sharedInstance().manufacturerName?.description
                cell.detailTextLabel!.text = "manufacturer name"
            case Section.DeviceInfo.modelNumber.rawValue:
                cell.textLabel!.text = ContinuousGlucose.sharedInstance().modelNumber?.description
                cell.detailTextLabel!.text = "model number"
            case Section.DeviceInfo.serialNumber.rawValue:
                cell.textLabel!.text = ContinuousGlucose.sharedInstance().serialNumber?.description
                cell.detailTextLabel!.text = "serial number"
            case Section.DeviceInfo.firmwareVersion.rawValue:
                cell.textLabel!.text = ContinuousGlucose.sharedInstance().firmwareVersion?.description
                cell.detailTextLabel!.text = "firmware version"
            default:
                print("")
            }
        case Section.features.rawValue:
            if continuousGlucoseFeatures != nil {
                switch indexPath.row {
                case ContinuousGlucoseFeatures.Features.calibrationSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.calibrationSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.calibrationSupported.description
                case ContinuousGlucoseFeatures.Features.patientHighLowAlertsSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.patientHighLowAlertsSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.patientHighLowAlertsSupported.description
                case ContinuousGlucoseFeatures.Features.hypoAlertsSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.hypoAlertsSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.hypoAlertsSupported.description
                case ContinuousGlucoseFeatures.Features.hyperAlertsSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.hyperAlertsSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.hyperAlertsSupported.description
                case ContinuousGlucoseFeatures.Features.rateOfIncreaseDecreaseAlertsSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.rateOfIncreaseDecreaseAlertsSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.rateOfIncreaseDecreaseAlertsSupported.description
                case ContinuousGlucoseFeatures.Features.deviceSpecificAlertSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.deviceSpecificAlertSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.deviceSpecificAlertSupported.description
                case ContinuousGlucoseFeatures.Features.sensorMalfunctionDetectionSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.sensorMalfunctionDetectionSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.sensorMalfunctionDetectionSupported.description
                case ContinuousGlucoseFeatures.Features.sensorTemperatureHighLowDetectionSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.sensorTemperatureHighLowDetectionSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.sensorTemperatureHighLowDetectionSupported.description
                case ContinuousGlucoseFeatures.Features.sensorResultHighLowDetectionSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.sensorResultHighLowDetectionSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.sensorResultHighLowDetectionSupported.description
                case ContinuousGlucoseFeatures.Features.lowBatteryDetectionSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.lowBatteryDetectionSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.lowBatteryDetectionSupported.description
                case ContinuousGlucoseFeatures.Features.sensorTypeErrorDetectionSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.sensorTypeErrorDetectionSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.sensorTypeErrorDetectionSupported.description
                case ContinuousGlucoseFeatures.Features.generalDeviceFaultSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.generalDeviceFaultSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.generalDeviceFaultSupported.description
                case ContinuousGlucoseFeatures.Features.e2eCRCSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.e2eCRCSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.e2eCRCSupported.description
                case ContinuousGlucoseFeatures.Features.multipleBondSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.multipleBondSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.multipleBondSupported.description
                case ContinuousGlucoseFeatures.Features.multipleSessionsSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.multipleSessionsSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.multipleSessionsSupported.description
                case ContinuousGlucoseFeatures.Features.cgmTrendInformationSupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.cgmTrendInformationSupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.cgmTrendInformationSupported.description
                case ContinuousGlucoseFeatures.Features.cgmQualitySupported.rawValue:
                    cell.textLabel!.text = continuousGlucoseFeatures.cgmQualitySupported?.description
                    cell.detailTextLabel!.text = ContinuousGlucoseFeatures.Features.cgmQualitySupported.description
                default:
                    print("")
                }
            }
        case Section.cgmType.rawValue:
            cell.textLabel!.text = ContinuousGlucoseFeatures.CMGTypes(rawValue: continuousGlucoseFeatures.cgmType!)!.description
            cell.detailTextLabel!.text = "type"
        case Section.cgmSampleLocation.rawValue:
            cell.textLabel!.text = ContinuousGlucoseFeatures.CGMSampleLocations(rawValue: continuousGlucoseFeatures.cgmSampleLocation!)!.description
            cell.detailTextLabel!.text = "location"
        case Section.timeOffset.rawValue:
            cell.textLabel!.text = continuousGlucoseStatus.timeOffset.description
            cell.detailTextLabel!.text = "time offset"
        case Section.numberOfRecords.rawValue:
            cell.textLabel!.text = glucoseMeasurementCount.description
            cell.detailTextLabel!.text = "records"
        case Section.startTime.rawValue:
            cell.textLabel!.text = ContinuousGlucose.sharedInstance().sessionStartTime?.description
            cell.detailTextLabel!.text = "date"
        case Section.runTime.rawValue:
            cell.textLabel!.text = self.sessionRunTime.description
            cell.detailTextLabel!.text = "minutes"
        case Section.session.rawValue:
            cell.textLabel!.text = "start session"
            cell.detailTextLabel!.text = ""
        case Section.specificOpsControlPoint.rawValue:
            switch indexPath.row {
                case Section.SpecificOpsControlPoint.getCGMCommunicationInterval.rawValue:
                    cell.textLabel!.text = ContinuousGlucose.sharedInstance().continuousGlucoseSOCP.cgmCommunicationInterval.description
                    cell.detailTextLabel!.text = "communication interval (minutes)"
                case Section.SpecificOpsControlPoint.getGlucoseCalibrationValue.rawValue:
                    cell.textLabel!.text = "N/A"
                    cell.detailTextLabel!.text = "glucose calibration value"
                case Section.SpecificOpsControlPoint.getPatientHighAlertLevel.rawValue:
                    cell.textLabel!.text = ContinuousGlucose.sharedInstance().continuousGlucoseSOCP.patientHighAlertLevel.description
                    cell.detailTextLabel!.text = "patient high alert level"
                case Section.SpecificOpsControlPoint.getPatientLowAlertLevel.rawValue:
                    cell.textLabel!.text = ContinuousGlucose.sharedInstance().continuousGlucoseSOCP.patientLowAlertLevel.description
                    cell.detailTextLabel!.text = "patient low alert level"
                case Section.SpecificOpsControlPoint.getHypoAlertLevel.rawValue:
                    cell.textLabel!.text = ContinuousGlucose.sharedInstance().continuousGlucoseSOCP.hypoAlertLevel.description
                    cell.detailTextLabel!.text = "hypo alert level"
                case Section.SpecificOpsControlPoint.getHyperAlertLevel.rawValue:
                    cell.textLabel!.text = ContinuousGlucose.sharedInstance().continuousGlucoseSOCP.hyperAlertLevel.description
                    cell.detailTextLabel!.text = "hyper alert level"
                case Section.SpecificOpsControlPoint.getRateOfDecreaseAlertLevel.rawValue:
                    cell.textLabel!.text = ContinuousGlucose.sharedInstance().continuousGlucoseSOCP.rateOfDecreaseAlertLevel.description
                    cell.detailTextLabel!.text = "rate of decrease alert level"
                case Section.SpecificOpsControlPoint.getRateOfIncreaseAlertLevel.rawValue:
                    cell.textLabel!.text = ContinuousGlucose.sharedInstance().continuousGlucoseSOCP.rateOfIncreaseAlertLevel.description
                    cell.detailTextLabel!.text = "rate of increase alert level"
                default:
                    cell.textLabel!.text = ""
                    cell.detailTextLabel!.text = ""
            }
        case Section.status.rawValue:
            if continuousGlucoseStatus != nil {
                switch indexPath.row {
                    case ContinuousGlucoseAnnunciation.Annunciation.sessionStopped.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sessionStopped?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sessionStopped.description
                    case ContinuousGlucoseAnnunciation.Annunciation.deviceBatteryLow.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.deviceBatteryLow?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.deviceBatteryLow.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorTypeIncorrectForDevice.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorTypeIncorrectForDevice?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorTypeIncorrectForDevice.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorMalfunction.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorMalfunction?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorMalfunction.description
                    case ContinuousGlucoseAnnunciation.Annunciation.deviceSpecificAlert.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.deviceSpecificAlert?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.deviceSpecificAlert.description
                    case ContinuousGlucoseAnnunciation.Annunciation.generalDeviceFaultHasOccurredInTheSensor.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.generalDeviceFaultHasOccurredInTheSensor?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.generalDeviceFaultHasOccurredInTheSensor.description
                    case ContinuousGlucoseAnnunciation.Annunciation.timeSynchronizationBetweenSensorAndCollectorRequired.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.timeSynchronizationBetweenSensorAndCollectorRequired?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.timeSynchronizationBetweenSensorAndCollectorRequired.description
                    case ContinuousGlucoseAnnunciation.Annunciation.calibrationNotAllowed.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.calibrationNotAllowed?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.calibrationNotAllowed.description
                    case ContinuousGlucoseAnnunciation.Annunciation.calibrationRecommended.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.calibrationRecommended?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.calibrationRecommended.description
                    case ContinuousGlucoseAnnunciation.Annunciation.calibrationRequired.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.calibrationRequired?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.calibrationRequired.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorTemperatureTooHighForValidTestResultAtTimeOfMeasurement.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorTemperatureTooHighForValidTestResultAtTimeOfMeasurement?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorTemperatureTooHighForValidTestResultAtTimeOfMeasurement.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorTemperatureTooLowForValidTestResultAtTimeOfMeasurement.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorTemperatureTooLowForValidTestResultAtTimeOfMeasurement?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorTemperatureTooLowForValidTestResultAtTimeOfMeasurement.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorResultLowerThanThePatientLowLevel.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorResultLowerThanThePatientLowLevel?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorResultLowerThanThePatientLowLevel.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorResultHigherThanThePatientHighLevel.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorResultHigherThanThePatientHighLevel?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorResultHigherThanThePatientHighLevel.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorResultLowerThanTheHypoLevel.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorResultLowerThanTheHypoLevel?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorResultLowerThanTheHypoLevel.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorResultHigherThanTheHyperLevel.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorResultHigherThanTheHyperLevel?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorResultHigherThanTheHyperLevel.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorRateOfDecreaseExceeded.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorRateOfDecreaseExceeded?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorRateOfDecreaseExceeded.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorRateOfIncreaseExceeded.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorRateOfIncreaseExceeded?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorRateOfIncreaseExceeded.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorResultLowerThanTheDeviceCanProcess.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorResultLowerThanTheDeviceCanProcess?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorResultLowerThanTheDeviceCanProcess.description
                    case ContinuousGlucoseAnnunciation.Annunciation.sensorResultHigherThanTheDeviceCanProcess.rawValue:
                        cell.textLabel!.text = continuousGlucoseStatus.status.sensorResultHigherThanTheDeviceCanProcess?.description
                        cell.detailTextLabel!.text = ContinuousGlucoseAnnunciation.Annunciation.sensorResultHigherThanTheDeviceCanProcess.description
                    default:
                        cell.textLabel!.text = ""
                        cell.detailTextLabel!.text = ""
                }
            }
        default:
            cell.textLabel!.text = ""
            cell.detailTextLabel!.text = ""
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionType = Section(rawValue: section)
        return sectionType?.description() ?? "none"
    }
    
    //MARK table delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == Section.session.rawValue {
            ContinuousGlucose.sharedInstance().prepareSession()
            performSegue(withIdentifier: "segueToSession", sender: self)
        }
    }

    func refreshTable() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
}

extension CGMViewController: ContinuousGlucoseProtocol {
    func continuousGlucoseSessionStartTimeUpdated() {
        print("continuousGlucoseSessionStartTimeUpdated")
        self.refreshTable()
    }

    func continuousGlucoseSOCPUpdated() {
        print("continuousGlucoseSOCPUpdated")
        self.refreshTable()
    }

    func continuousGlucoseSessionRunTime(runTime: UInt16) {
        print("CGMViewController#continuousGlucoseSessionRunTime - \(runTime)")
        self.sessionRunTime = runTime
    }

    func continuousGlucoseNumberOfStoredRecords(number: UInt16) {
        print("CGMViewController#numberOfStoredRecords - \(number)")
        glucoseMeasurementCount = number
        self.refreshTable()
    }

    func continuousGlucoseFeatures(features: ContinuousGlucoseFeatures) {
        print("CGMViewController#continuousGlucoseFeatures")
        continuousGlucoseFeatures = features
        
        self.refreshTable()
    }
    
    func continuousGlucoseStatus(status: ContinuousGlucoseStatus) {
        print("CGMViewController#continuousGlucoseStatus")
        continuousGlucoseStatus = status
        
        self.refreshTable()
    }
    
    func continuousGlucoseMeterConnected(meter: CBPeripheral) {
        continuousGlucoseMeterConnected = true
    }
    
    func continuousGlucoseMeterDisconnected(meter: CBPeripheral) {
        continuousGlucoseMeterConnected = false
    }
}
