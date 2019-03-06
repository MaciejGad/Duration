//
//  DurationComponent.swift
//  Duration
//
//  Created by Maciej Gad on 06/03/2019.
//  Copyright © 2019 MaciejGad. All rights reserved.
//

import Foundation

enum Component {
    case second
    case minute
    case hour
    case day
    case week
    case month
    case year
    
    func timeInterval() -> TimeInterval {
        switch self {
        case .second:
            return .second
        case .minute:
            return .minute
        case .hour:
            return .hour
        case .day:
            return .day
        case .week:
            return .week
        case .month:
            return .month
        case .year:
            return .year
        }
    }
    
    func stepDown() -> (duration:Int, component:Component) {
        switch self {
        case .year:
            return (duration: 12, component:.month)
        case .month:
            return (duration: 30, component:.day)
        case .week:
            return (duration: 7, component:.day)
        case .day:
            return (duration: 24, component:.hour)
        case .hour:
            return (duration: 60, component:.minute)
        case .minute:
            return  (duration:60, component:.second)
        case .second:
            return (duration: 1, component:.second)
        }
    }
    
    func toCalendarComponent() -> Calendar.Component {
        switch self {
        case .year:
            return .year
        case .month:
            return .month
        case .week:
            return .day
        case .day:
            return .day
        case .hour:
            return .hour
        case .minute:
            return .minute
        case .second:
            return .second
        }
    }
    
    func value(duration:Double) -> [ComponentDuration] {
        var correctedDuration = duration
        if self == .week {
            correctedDuration *= 7
        }
        let intValue = Int(correctedDuration.rounded(.down))
        var output:[ComponentDuration] = []
        
        output.append(ComponentDuration(duration: intValue, component: self.toCalendarComponent()))
        let remainedDuration =  duration - Double(intValue)
        if remainedDuration > 0.0001 {
            let step = self.stepDown()
            let recalculatedRemainedDuration =  Double(step.duration) * remainedDuration
            let intRecalculatedRemainedDuration = Int(recalculatedRemainedDuration.rounded(.down))
            output.append(ComponentDuration(duration: intRecalculatedRemainedDuration, component: step.component.toCalendarComponent()))
        }
        return output
    }
}

struct ComponentDuration {
    let duration:Int
    let component:Calendar.Component
}

extension TimeInterval {
    static let second = 1.0
    static let minute = 60 * TimeInterval.second
    static let hour = 60 * TimeInterval.minute
    static let day = 24 * TimeInterval.hour
    static let week = 7 * TimeInterval.day
    static let month = 30 * TimeInterval.day
    static let year = 365.25 * TimeInterval.day
}
