//
//  Duration.swift
//  Duration
//
//  Created by Maciej Gad on 05/03/2019.
//  Copyright © 2019 MaciejGad. All rights reserved.
//

import Foundation


public struct Duration:Codable {
    public let timeInterval:TimeInterval
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let textValue = try container.decode(String.self)
        guard textValue.hasPrefix("P") else {
            throw Errors.notBeginWithP
        }
        var timeInterval:TimeInterval = 0
        var numberValue:String = ""
        let numbers = Set("0123456789.,")
        var isTimePart = false
        
        func addTimeInterval(base:TimeInterval) {
            if let value = Double(numberValue.replacingOccurrences(of: ",", with: ".")) {
                timeInterval += value * base
            }
            numberValue = ""
        }
        
        for char in textValue {
            switch char {
            case "P":
                continue
            case "T":
                isTimePart = true
            case _ where numbers.contains(char):
                numberValue.append(char)
            case "D":
                addTimeInterval(base: .day)
            case "Y":
                addTimeInterval(base: .year)
            case "M":
                if isTimePart {
                    addTimeInterval(base: .minute)
                } else {
                    addTimeInterval(base: .day * 30)
                }
            case "W":
                addTimeInterval(base: .week)
            case "H":
                if isTimePart {
                    addTimeInterval(base: .hour)
                } else {
                    throw Errors.timePartNotBeginWithT
                }
            case "S":
                if isTimePart {
                    addTimeInterval(base: 1)
                } else {
                    throw Errors.timePartNotBeginWithT
                }
            default:
                throw Errors.unknownElement
            }
        }
        if numberValue.count > 0 {
            throw Errors.discontinuous
        }
        self.timeInterval = timeInterval
    }
    
    enum Errors:Error {
        case notBeginWithP
        case timePartNotBeginWithT
        case unknownElement
        case discontinuous

    }
}

extension TimeInterval {
    static let minute = 60.0
    static let hour = 60 * TimeInterval.minute
    static let day = 24 * TimeInterval.hour
    static let week = 7 * TimeInterval.day
    static let year = 365.25 * TimeInterval.day
}
