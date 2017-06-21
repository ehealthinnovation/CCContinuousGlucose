//
//  CGMFhir.swift
//  CCContinuousGlucose
//
//  Created by Kevin Tallevi on 6/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import CCContinuousGlucose
import SMART

public class CGMFhir: NSObject {
    static let CGMFhirInstance: CGMFhir = CGMFhir()
    var patient: Patient?
    var device: Device?
    var givenName: String = "Lisa"
    var familyName: String = "Simpson"
    
    public func createPatient(callback: @escaping (_ patient: Patient, _ error: Error?) -> Void) {
        //let patientName = HumanName(json: nil)
        let patientName = HumanName(json: <#T##FHIRJSON#>)
        patientName.family = [self.familyName]
        patientName.given = [self.givenName]
        patientName.use = "official"
        
        let patientTelecom = ContactPoint(json: nil)
        patientTelecom.use = "work"
        patientTelecom.value = "4163404800"
        patientTelecom.system = "phone"
        
        let patientAddress = Address(json: nil)
        patientAddress.city = "Toronto"
        patientAddress.country = "Canada"
        patientAddress.postalCode = "M5G2C4"
        patientAddress.line = ["585 University Ave"]
        
        let patientBirthDate = FHIRDate(string: DateTime.now.date.description)
        
        let patient = Patient(json: nil)
        patient.active = true
        patient.name = [patientName]
        patient.telecom = [patientTelecom]
        patient.address = [patientAddress]
        patient.birthDate = patientBirthDate
        
        FHIR.fhirInstance.createPatient(patient: patient) { patient, error in
            if let error = error {
                print("error creating patient: \(error)")
            } else {
                self.patient = patient
            }
            callback(patient, error)
        }
    }
    
    public func searchForPatient(given: String, family: String, callback: @escaping FHIRSearchBundleErrorCallback) {
        print("GlucoseMeterViewController: searchForPatient")
        let searchDict: [String:Any] = [
            "given": given,
            "family": family
        ]
        
        FHIR.fhirInstance.searchForPatient(searchParameters: searchDict) { (bundle, error) -> Void in
            if let error = error {
                print("error searching for patient: \(error)")
            }
            
            if bundle?.entry == nil {
                
            } else {
                if bundle?.entry != nil {
                    let patients = bundle?.entry?
                        .filter { return $0.resource is Patient }
                        .map { return $0.resource as! Patient }
                    
                    self.patient = patients?[0]
                }
            }
            callback(bundle, error)
        }
    }
    
    public func createDevice(callback: @escaping (_ device: Device, _ error: Error?) -> Void) {
        let modelNumber = ContinuousGlucose.sharedInstance().modelNumber?.replacingOccurrences(of: "\0", with: "")
        let manufacturer = ContinuousGlucose.sharedInstance().manufacturerName!.replacingOccurrences(of: "\0", with: "")
        let serialNumber = ContinuousGlucose.sharedInstance().serialNumber!.replacingOccurrences(of: "\0", with: "")
        
        let deviceCoding = Coding(json: nil)
        deviceCoding.code = "337414009"
        deviceCoding.system = URL(string: "http://snomed.info/sct")
        deviceCoding.display = "Blood glucose meters (physical object)"
        
        let deviceType = CodeableConcept(json: nil)
        deviceType.coding = [deviceCoding]
        deviceType.text = "Glucose Meter"
        
        let deviceIdentifierTypeCoding = Coding(json: nil)
        deviceIdentifierTypeCoding.system = URL(string: "http://hl7.org/fhir/identifier-type")
        deviceIdentifierTypeCoding.code = "SNO"
        
        let deviceIdentifierType = CodeableConcept(json: nil)
        deviceIdentifierType.coding = [deviceIdentifierTypeCoding]
        
        let deviceIdentifier = Identifier(json: nil)
        deviceIdentifier.value = serialNumber
        deviceIdentifier.type = deviceIdentifierType
        deviceIdentifier.system = URL(string: "http://www.company.com/products/product/serial")
        
        let device = Device(json: nil)
        device.status = "available"
        device.manufacturer = manufacturer
        device.model = modelNumber
        device.type = deviceType
        device.identifier = [deviceIdentifier]
        
        FHIR.fhirInstance.createDevice(device: device) { device, error in
            if let error = error {
                print("error creating device: \(error)")
            } else {
                self.device = device
            }
            callback(device, error)
        }
    }
    
    public func searchForDevice(callback: @escaping FHIRSearchBundleErrorCallback) {
        let modelNumber = ContinuousGlucose.sharedInstance().modelNumber?.replacingOccurrences(of: "\0", with: "")
        let manufacturer = ContinuousGlucose.sharedInstance().manufacturerName?.replacingOccurrences(of: "\0", with: "")
        
        let encodedModelNumber: String = modelNumber!.replacingOccurrences(of: " ", with: "+")
        let encodedMmanufacturer: String = manufacturer!.replacingOccurrences(of: " ", with: "+")
        
        let searchDict: [String:Any] = [
            "model": encodedModelNumber,
            "manufacturer": encodedMmanufacturer,
            "identifier": ContinuousGlucose.sharedInstance().serialNumber!
        ]
        
        FHIR.fhirInstance.searchForDevice(searchParameters: searchDict) { (bundle, error) -> Void in
            if let error = error {
                print("error searching for device: \(error)")
            }
            
            if bundle?.entry == nil {
                
            } else {
                if bundle?.entry != nil {
                    let devices = bundle?.entry?
                        .filter { return $0.resource is Device }
                        .map { return $0.resource as! Device }
                    
                    self.device = devices?[0]
                }
            }
            callback(bundle, error)
        }
    }
    
    public func measurementToObservation(measurement: ContinuousGlucoseMeasurement) -> Observation {
        var codingArray = [Coding]()
        let coding = Coding(json: nil)
        coding.system = URL(string: "http://loinc.org")
        coding.code = "15074-8"
        coding.display = "Glucose [Moles/volume] in Blood"
        codingArray.append(coding)
        
        let codableConcept = CodeableConcept(json: nil)
        codableConcept.coding = codingArray as [Coding]
        
        let deviceReference = Reference(json: nil)
        deviceReference.reference = "Device/" + (self.device?.id)!
        
        let subjectReference = Reference(json: nil)
        subjectReference.reference = "Patient/" + (self.patient?.id)!
        
        var performerArray = [Reference]()
        let performerReference = Reference(json: nil)
        performerReference.reference = "Patient/" + (self.patient?.id)!
        performerArray.append(performerReference)
        
        let measurementNumber = NSDecimalNumber(value: self.truncateMeasurement(measurementValue: measurement.toMMOL()!))
        let decimalRoundingBehaviour = NSDecimalNumberHandler(roundingMode:.plain,
                                                              scale: 2, raiseOnExactness: false,
                                                              raiseOnOverflow: false, raiseOnUnderflow:
            false, raiseOnDivideByZero: false)
        
        let quantity = Quantity.init(json: nil)
        quantity.value = measurementNumber.rounding(accordingToBehavior: decimalRoundingBehaviour)
        quantity.code = "mmol/L"
        quantity.system = URL(string: "http://unitsofmeasure.org")
        quantity.unit = "mmol/L"
        
        let effectivePeriod = Period(json: nil)
        
        let date: Date = (ContinuousGlucose.sharedInstance().sessionStartTime?.addingTimeInterval(TimeInterval(measurement.timeOffset * 60)))!
        effectivePeriod.start = DateTime(string: (date.iso8601))
        effectivePeriod.end = DateTime(string: (date.iso8601))
        
        let observation = Observation.init(json: nil)
        observation.status = "final"
        observation.code = codableConcept
        observation.valueQuantity = quantity
        observation.effectivePeriod = effectivePeriod
        observation.device = deviceReference
        observation.subject = subjectReference
        observation.performer = performerArray
        
        return observation
    }
    
    public func truncateMeasurement(measurementValue: Float) -> Float {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = NumberFormatter.RoundingMode.down
        let truncatedValue = formatter.string(from: NSNumber(value: measurementValue))
        
        return Float(truncatedValue!)!
    }
    
    public func uploadSingleMeasurement(measurement: ContinuousGlucoseMeasurement) {
        if measurement.existsOnFHIR == false {
            FHIR.fhirInstance.createObservation(observation: self.measurementToObservation(measurement: measurement)) { (observation, error) -> Void in
                guard error == nil else {
                    print("error creating observation: \(String(describing: error))")
                    return
                }
                
                print("observation uploaded with id: \(observation.id!)")
                measurement.existsOnFHIR = true
                measurement.fhirID = observation.id!
            }
        }
    }
}
