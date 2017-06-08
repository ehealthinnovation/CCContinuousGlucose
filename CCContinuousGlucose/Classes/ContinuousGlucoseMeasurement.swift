//
//  ContinuousGlucoseMeasurement.swift
//  Pods
//
//  Created by Kevin Tallevi on 4/19/17.
//
// https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.cgm_measurement.xml

import Foundation
import CCToolbox

public class ContinuousGlucoseMeasurement : NSObject {
    public var packetSize: UInt16 = 0
    public var cgmTrendInformationPresent: Bool?
    public var cgmQualityPresent: Bool?
    public var sensorStatusAnnunciationFieldWarningOctetPresent: Bool?
    public var sensorStatusAnnunciationFieldCalTempOctetPresent: Bool?
    public var sensorStatusAnnunciationFieldStatusOctetPresent: Bool?
    public var glucoseConcentration: Float = 0
    public var timeOffset: UInt16 = 0
    public var status: ContinuousGlucoseAnnunciation!
    public var trendValue: Float = 0
    public var quality: Float = 0
    
    private let flagsRange = NSRange(location:1, length: 1)
    private let glucoseConcentrationRange = NSRange(location:2, length: 2)
    private let timeOffsetRange = NSRange(location:4, length: 2)
    private let annunciationRange = NSRange(location:6, length: 1)
    private let trendRange = NSRange(location:7, length: 2)
    private let qualityRange = NSRange(location:9, length: 2)
    
    private let cgmTrendInformationPresentBit = 0
    private let cgmQualityPresentBit = 1
    private let sensorStatusAnnunciationFieldWarningOctetPresentBit = 5
    private let sensorStatusAnnunciationFieldCalTempOctetPresentBit = 6
    private let sensorStatusAnnunciationFieldStatusOctetPresentBit = 7

    
    init(data: NSData?) {
        super.init()
        parseFlags(flags:(data?.subdata(with: flagsRange) as NSData!))
        parseGlucoseConcentration(data:(data?.subdata(with: glucoseConcentrationRange) as NSData!))
        parseTimeOffset(data:(data?.subdata(with: timeOffsetRange) as NSData!))
        parseAnnunciation(data:(data?.subdata(with: annunciationRange) as NSData!))
        parseTrend(data:(data?.subdata(with: trendRange) as NSData!))
        parseQuality(data:(data?.subdata(with: qualityRange) as NSData!))
    }
    
    func parseFlags(flags: NSData) {
        var flagBits:Int = 0
        flags.getBytes(&flagBits, length: 1)
        cgmTrendInformationPresent = flagBits.bit(cgmTrendInformationPresentBit).toBool()
        cgmQualityPresent = flagBits.bit(cgmQualityPresentBit).toBool()
        sensorStatusAnnunciationFieldWarningOctetPresent = flagBits.bit(sensorStatusAnnunciationFieldWarningOctetPresentBit).toBool()
        sensorStatusAnnunciationFieldCalTempOctetPresent = flagBits.bit(sensorStatusAnnunciationFieldCalTempOctetPresentBit).toBool()
        sensorStatusAnnunciationFieldStatusOctetPresent = flagBits.bit(sensorStatusAnnunciationFieldStatusOctetPresentBit).toBool()
    }
    
    func parseGlucoseConcentration(data: NSData) {
        self.glucoseConcentration = data.shortFloatToFloat()
        print("glucose concentration: \(glucoseConcentration)")
    }
    
    func parseTimeOffset(data: NSData) {
        data.getBytes(&timeOffset, length: 2)
        print("time offset: \(timeOffset)")
    }
    
    func parseAnnunciation(data: NSData) {
        self.status = ContinuousGlucoseAnnunciation(data: data)
    }
    
    func parseTrend(data: NSData) {
        trendValue = data.shortFloatToFloat()
        print("trend [(mg/dL)/min]: \(trendValue)")
    }
    
    func parseQuality(data: NSData) {
        quality = data.shortFloatToFloat()
        print("quality(%): \(quality)")
    }
}
