//
//  ContinuousGlucoseAnnunciation.swift
//  Pods
//
//  Created by Kevin Tallevi on 4/19/17.
//
//

import Foundation
import CCToolbox

public class ContinuousGlucoseAnnunciation : NSObject {
    public var sessionStopped: Bool?
    public var deviceBatteryLow: Bool?
    public var sensorTypeIncorrectForDevice: Bool?
    public var sensorMalfunction: Bool?
    public var deviceSpecificAlert: Bool?
    public var generalDeviceFaultHasOccurredInTheSensor: Bool?
    public var timeSynchronizationBetweenSensorAndCollectorRequired: Bool?
    public var calibrationNotAllowed: Bool?
    public var calibrationRecommended: Bool?
    public var calibrationRequired: Bool?
    public var sensorTemperatureTooHighForValidTestResultAtTimeOfMeasurement: Bool?
    public var sensorTemperatureTooLowForValidTestResultAtTimeOfMeasurement: Bool?
    public var sensorResultLowerThanThePatientLowLevel: Bool?
    public var sensorResultHigherThanThePatientHighLevel: Bool?
    public var sensorResultLowerThanTheHypoLevel: Bool?
    public var sensorResultHigherThanTheHyperLevel: Bool?
    public var sensorRateOfDecreaseExceeded: Bool?
    public var sensorRateOfIncreaseExceeded: Bool?
    public var sensorResultLowerThanTheDeviceCanProcess: Bool?
    public var sensorResultHigherThanTheDeviceCanProcess: Bool?
    
    private let sessionStoppedBit = 0
    private let deviceBatteryLowBit = 1
    private let sensorTypeIncorrectForDeviceBit = 2
    private let sensorMalfunctionBit = 3
    private let deviceSpecificAlertBit = 4
    private let generalDeviceFaultHasOccurredInTheSensorBit = 5
    private let timeSynchronizationBetweenSensorAndCollectorRequiredBit = 8
    private let calibrationNotAllowedBit = 9
    private let calibrationRecommendedBit = 10
    private let calibrationRequiredBit = 11
    private let sensorTemperatureTooHighForValidTestResultAtTimeOfMeasurementBit = 12
    private let sensorTemperatureTooLowForValidTestResultAtTimeOfMeasurementBit = 13
    private let sensorResultLowerThanThePatientLowLevelBit = 16
    private let sensorResultHigherThanThePatientHighLevelBit = 17
    private let sensorResultLowerThanTheHypoLevelBit = 18
    private let sensorResultHigherThanTheHyperLevelBit = 19
    private let sensorRateOfDecreaseExceededBit = 20
    private let sensorRateOfIncreaseExceededBit = 21
    private let sensorResultLowerThanTheDeviceCanProcessBit = 22
    private let sensorResultHigherThanTheDeviceCanProcessBit = 23
    
    @objc public enum Annunciation : Int {
        case sessionStopped = 0,
        deviceBatteryLow,
        sensorTypeIncorrectForDevice,
        sensorMalfunction,
        deviceSpecificAlert,
        generalDeviceFaultHasOccurredInTheSensor,
        timeSynchronizationBetweenSensorAndCollectorRequired,
        calibrationNotAllowed,
        calibrationRecommended,
        calibrationRequired,
        sensorTemperatureTooHighForValidTestResultAtTimeOfMeasurement,
        sensorTemperatureTooLowForValidTestResultAtTimeOfMeasurement,
        sensorResultLowerThanThePatientLowLevel,
        sensorResultHigherThanThePatientHighLevel,
        sensorResultLowerThanTheHypoLevel,
        sensorResultHigherThanTheHyperLevel,
        sensorRateOfDecreaseExceeded,
        sensorRateOfIncreaseExceeded,
        sensorResultLowerThanTheDeviceCanProcess,
        sensorResultHigherThanTheDeviceCanProcess,
        reserved
        
        public var description: String {
            switch self {
            case .sessionStopped:
                return NSLocalizedString("Session Stopped", comment:"")
            case .deviceBatteryLow:
                return NSLocalizedString("Patient High Low Alerts Supported", comment:"")
            case .sensorTypeIncorrectForDevice:
                return NSLocalizedString("Hypo Alerts Supported", comment:"")
            case .sensorMalfunction:
                return NSLocalizedString("Hypo Alerts Supported", comment:"")
            case .deviceSpecificAlert:
                return NSLocalizedString("Rate Of Increase Decrease Alerts Supported", comment:"")
            case .generalDeviceFaultHasOccurredInTheSensor:
                return NSLocalizedString("Device Specific Alert Supported", comment:"")
            case .timeSynchronizationBetweenSensorAndCollectorRequired:
                return NSLocalizedString("Sensor Malfunction Detection Supported", comment:"")
            case .calibrationNotAllowed:
                return NSLocalizedString("Sensor Temperature High Low Detection Supported", comment:"")
            case .calibrationRecommended:
                return NSLocalizedString("Sensor Result High Low Detection Supported", comment:"")
            case .calibrationRequired:
                return NSLocalizedString("Low Battery Detection Supported", comment:"")
            case .sensorTemperatureTooHighForValidTestResultAtTimeOfMeasurement:
                return NSLocalizedString("Sensor Type Error Detection Supported", comment:"")
            case .sensorTemperatureTooLowForValidTestResultAtTimeOfMeasurement:
                return NSLocalizedString("General Device Fault Supported", comment:"")
            case .sensorResultLowerThanThePatientLowLevel:
                return NSLocalizedString("E2E CRC Supported", comment:"")
            case .sensorResultHigherThanThePatientHighLevel:
                return NSLocalizedString("Multiple Bond Supported", comment:"")
            case .sensorResultLowerThanTheHypoLevel:
                return NSLocalizedString("Multiple Sessions Supported", comment:"")
            case .sensorResultHigherThanTheHyperLevel:
                return NSLocalizedString("CGM TrendInformationSupported", comment:"")
            case .sensorRateOfDecreaseExceeded:
                return NSLocalizedString("CGM Sensor Rate Of Decrease Exceeded", comment:"")
            case .sensorRateOfIncreaseExceeded:
                return NSLocalizedString("CGM Sensor Rate Of Increase Exceeded", comment:"")
            case .sensorResultLowerThanTheDeviceCanProcess:
                return NSLocalizedString("CGM Sensor Result Lower Than The Device Can Process", comment:"")
            case .sensorResultHigherThanTheDeviceCanProcess:
                return NSLocalizedString("CGM Sensor Result Higher Than The Device Can Process", comment:"")
            case .reserved:
                return NSLocalizedString("Reserved", comment:"")
            }
        }
    }
    
    init(data: NSData?) {
        var annunciationBits:Int = 0
        data?.getBytes(&annunciationBits, length: (data?.length)!)
        
        sessionStopped = annunciationBits.bit(sessionStoppedBit).toBool()
        deviceBatteryLow = annunciationBits.bit(deviceBatteryLowBit).toBool()
        sensorTypeIncorrectForDevice = annunciationBits.bit(sensorTypeIncorrectForDeviceBit).toBool()
        sensorMalfunction = annunciationBits.bit(sensorMalfunctionBit).toBool()
        deviceSpecificAlert = annunciationBits.bit(deviceSpecificAlertBit).toBool()
        generalDeviceFaultHasOccurredInTheSensor = annunciationBits.bit(generalDeviceFaultHasOccurredInTheSensorBit).toBool()
        timeSynchronizationBetweenSensorAndCollectorRequired = annunciationBits.bit(timeSynchronizationBetweenSensorAndCollectorRequiredBit).toBool()
        calibrationNotAllowed = annunciationBits.bit(calibrationNotAllowedBit).toBool()
        calibrationRecommended = annunciationBits.bit(calibrationRecommendedBit).toBool()
        calibrationRequired = annunciationBits.bit(calibrationRequiredBit).toBool()
        sensorTemperatureTooHighForValidTestResultAtTimeOfMeasurement = annunciationBits.bit(sensorTemperatureTooHighForValidTestResultAtTimeOfMeasurementBit).toBool()
        sensorTemperatureTooLowForValidTestResultAtTimeOfMeasurement = annunciationBits.bit(sensorTemperatureTooLowForValidTestResultAtTimeOfMeasurementBit).toBool()
        sensorResultLowerThanThePatientLowLevel = annunciationBits.bit(sensorResultLowerThanThePatientLowLevelBit).toBool()
        sensorResultHigherThanThePatientHighLevel = annunciationBits.bit(sensorResultHigherThanThePatientHighLevelBit).toBool()
        sensorResultLowerThanTheHypoLevel = annunciationBits.bit(sensorResultLowerThanTheHypoLevelBit).toBool()
        sensorResultHigherThanTheHyperLevel = annunciationBits.bit(sensorResultHigherThanTheHyperLevelBit).toBool()
        sensorRateOfDecreaseExceeded = annunciationBits.bit(sensorRateOfDecreaseExceededBit).toBool()
        sensorRateOfIncreaseExceeded = annunciationBits.bit(sensorRateOfIncreaseExceededBit).toBool()
        sensorResultLowerThanTheDeviceCanProcess = annunciationBits.bit(sensorResultLowerThanTheDeviceCanProcessBit).toBool()
        sensorResultHigherThanTheDeviceCanProcess = annunciationBits.bit(sensorResultHigherThanTheDeviceCanProcessBit).toBool()
    }
}
