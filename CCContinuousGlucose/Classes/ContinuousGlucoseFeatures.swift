//
//  ContinuousGlucoseFeatures.swift
//  Pods
//
//  Created by Kevin Tallevi on 4/7/17.
//
// https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.cgm_feature.xml

import Foundation
import CCToolbox

public class ContinuousGlucoseFeatures : NSObject {
    public var calibrationSupported: Bool?
    public var patientHighLowAlertsSupported: Bool?
    public var hypoAlertsSupported: Bool?
    public var hyperAlertsSupported: Bool?
    public var rateOfIncreaseDecreaseAlertsSupported: Bool?
    public var deviceSpecificAlertSupported: Bool?
    public var sensorMalfunctionDetectionSupported: Bool?
    public var sensorTemperatureHighLowDetectionSupported: Bool?
    public var sensorResultHighLowDetectionSupported: Bool?
    public var lowBatteryDetectionSupported: Bool?
    public var sensorTypeErrorDetectionSupported: Bool?
    public var generalDeviceFaultSupported: Bool?
    public var e2eCRCSupported: Bool?
    public var multipleBondSupported: Bool?
    public var multipleSessionsSupported: Bool?
    public var cgmTrendInformationSupported: Bool?
    public var cgmQualitySupported: Bool?
    public var cgmType: Int?
    public var cgmSampleLocation: Int?
    
    private var calibrationSupportedBit = 0
    private var patientHighLowAlertsSupportedBit = 1
    private var hypoAlertsSupportedBit = 2
    private var hyperAlertsSupportedBit = 3
    private var rateOfIncreaseDecreaseAlertsSupportedBit = 4
    private var deviceSpecificAlertSupportedBit = 5
    private var sensorMalfunctionDetectionSupportedBit = 6
    private var sensorTemperatureHighLowDetectionSupportedBit = 7
    private var sensorResultHighLowDetectionSupportedBit = 8
    private var lowBatteryDetectionSupportedBit = 9
    private var sensorTypeErrorDetectionSupportedBit = 10
    private var generalDeviceFaultSupportedBit = 11
    private var e2eCRCSupportedBit = 12
    private var multipleBondSupportedBit = 13
    private var multipleSessionsSupportedBit = 14
    private var cgmTrendInformationSupportedBit = 15
    private var cgmQualitySupportedBit = 16
    
    private var cgmTypeAndSampleLocationRange = NSRange(location:3, length: 1)
    
    
    @objc public enum Features : Int {
        case calibrationSupported = 0,
        patientHighLowAlertsSupported,
        hypoAlertsSupported,
        hyperAlertsSupported,
        rateOfIncreaseDecreaseAlertsSupported,
        deviceSpecificAlertSupported,
        sensorMalfunctionDetectionSupported,
        sensorTemperatureHighLowDetectionSupported,
        sensorResultHighLowDetectionSupported,
        lowBatteryDetectionSupported,
        sensorTypeErrorDetectionSupported,
        generalDeviceFaultSupported,
        e2eCRCSupported,
        multipleBondSupported,
        multipleSessionsSupported,
        cgmTrendInformationSupported,
        cgmQualitySupported,
        reserved
        
        public var description: String {
            switch self {
            case .calibrationSupported:
                return NSLocalizedString("Calibration Supported", comment:"")
            case .patientHighLowAlertsSupported:
                return NSLocalizedString("Patient High Low Alerts Supported", comment:"")
            case .hypoAlertsSupported:
                return NSLocalizedString("Hypo Alerts Supported", comment:"")
            case .hyperAlertsSupported:
                return NSLocalizedString("Hyper Alerts Supported", comment:"")
            case .rateOfIncreaseDecreaseAlertsSupported:
                return NSLocalizedString("Rate Of Increase Decrease Alerts Supported", comment:"")
            case .deviceSpecificAlertSupported:
                return NSLocalizedString("Device Specific Alert Supported", comment:"")
            case .sensorMalfunctionDetectionSupported:
                return NSLocalizedString("Sensor Malfunction Detection Supported", comment:"")
            case .sensorTemperatureHighLowDetectionSupported:
                return NSLocalizedString("Sensor Temperature High Low Detection Supported", comment:"")
            case .sensorResultHighLowDetectionSupported:
                return NSLocalizedString("Sensor Result High Low Detection Supported", comment:"")
            case .lowBatteryDetectionSupported:
                return NSLocalizedString("Low Battery Detection Supported", comment:"")
            case .sensorTypeErrorDetectionSupported:
                return NSLocalizedString("Sensor Type Error Detection Supported", comment:"")
            case .generalDeviceFaultSupported:
                return NSLocalizedString("General Device Fault Supported", comment:"")
            case .e2eCRCSupported:
                return NSLocalizedString("E2E CRC Supported", comment:"")
            case .multipleBondSupported:
                return NSLocalizedString("Multiple Bond Supported", comment:"")
            case .multipleSessionsSupported:
                return NSLocalizedString("Multiple Sessions Supported", comment:"")
            case .cgmTrendInformationSupported:
                return NSLocalizedString("CGM TrendInformationSupported", comment:"")
            case .cgmQualitySupported:
                return NSLocalizedString("CGM QualitySupported", comment:"")
            case .reserved:
                return NSLocalizedString("Reserved", comment:"")
            }
        }
    }
    
    init(data: NSData?) {
        super.init()
        
        var featureBits:Int = 0
        data?.getBytes(&featureBits, length: 3)
        
        calibrationSupported = featureBits.bit(calibrationSupportedBit).toBool()
        patientHighLowAlertsSupported = featureBits.bit(patientHighLowAlertsSupportedBit).toBool()
        hypoAlertsSupported = featureBits.bit(hypoAlertsSupportedBit).toBool()
        hyperAlertsSupported = featureBits.bit(hyperAlertsSupportedBit).toBool()
        rateOfIncreaseDecreaseAlertsSupported = featureBits.bit(rateOfIncreaseDecreaseAlertsSupportedBit).toBool()
        deviceSpecificAlertSupported = featureBits.bit(deviceSpecificAlertSupportedBit).toBool()
        sensorMalfunctionDetectionSupported = featureBits.bit(sensorMalfunctionDetectionSupportedBit).toBool()
        sensorTemperatureHighLowDetectionSupported = featureBits.bit(sensorTemperatureHighLowDetectionSupportedBit).toBool()
        sensorResultHighLowDetectionSupported = featureBits.bit(sensorResultHighLowDetectionSupportedBit).toBool()
        lowBatteryDetectionSupported = featureBits.bit(lowBatteryDetectionSupportedBit).toBool()
        sensorTypeErrorDetectionSupported = featureBits.bit(sensorTypeErrorDetectionSupportedBit).toBool()
        generalDeviceFaultSupported = featureBits.bit(generalDeviceFaultSupportedBit).toBool()
        e2eCRCSupported = featureBits.bit(e2eCRCSupportedBit).toBool()
        multipleBondSupported = featureBits.bit(multipleBondSupportedBit).toBool()
        multipleSessionsSupported = featureBits.bit(multipleSessionsSupportedBit).toBool()
        cgmTrendInformationSupported = featureBits.bit(cgmTrendInformationSupportedBit).toBool()
        cgmQualitySupported = featureBits.bit(cgmQualitySupportedBit).toBool()
        
        let cgmTypeAndSampleLocation = (data?.subdata(with: cgmTypeAndSampleLocationRange) as NSData!)
        cgmType = (cgmTypeAndSampleLocation?.lowNibbleAtPosition())!
        cgmSampleLocation = (cgmTypeAndSampleLocation?.highNibbleAtPosition())!
    }
}
