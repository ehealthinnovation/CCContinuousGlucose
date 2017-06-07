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
    
    private var sessionStoppedBit = 0
    private var deviceBatteryLowBit = 1
    private var sensorTypeIncorrectForDeviceBit = 2
    private var sensorMalfunctionBit = 3
    private var deviceSpecificAlertBit = 4
    private var generalDeviceFaultHasOccurredInTheSensorBit = 5
    private var timeSynchronizationBetweenSensorAndCollectorRequiredBit = 8
    private var calibrationNotAllowedBit = 9
    private var calibrationRecommendedBit = 10
    private var calibrationRequiredBit = 11
    private var sensorTemperatureTooHighForValidTestResultAtTimeOfMeasurementBit = 12
    private var sensorTemperatureTooLowForValidTestResultAtTimeOfMeasurementBit = 13
    private var sensorResultLowerThanThePatientLowLevelBit = 16
    private var sensorResultHigherThanThePatientHighLevelBit = 17
    private var sensorResultLowerThanTheHypoLevelBit = 18
    private var sensorResultHigherThanTheHyperLevelBit = 19
    private var sensorRateOfDecreaseExceededBit = 20
    private var sensorRateOfIncreaseExceededBit = 21
    private var sensorResultLowerThanTheDeviceCanProcessBit = 22
    private var sensorResultHigherThanTheDeviceCanProcessBit = 23
    
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
