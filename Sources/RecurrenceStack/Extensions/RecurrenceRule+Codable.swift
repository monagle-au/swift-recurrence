//
//  RecurrenceRule+Codable.swift
//  Recurrence
//
//  Created by David Monagle on 6/3/19.
//  Copyright © 2019 Monagle. All rights reserved.
//

import RecurrenceCore
import Foundation

extension RecurrenceRule: Codable {
    internal enum CodingKeys: String, CodingKey {
        case _version, baseType, every, days, monthlyOrdinal, daysOfWeek, months
    }
    
    public enum Repetition : String, Codable {
        case daily, weekly, monthly, monthlyOrdinal, annually, annuallyOrdinal
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let baseType = try container.decode(Repetition.self, forKey: .baseType)
        
        switch baseType {
        case .daily:
            let interval = try container.decode(Int.self, forKey: .every)
            self = .daily(every: interval)
        case .weekly:
            let interval = try container.decode(Int.self, forKey: .every)
            let days = try container.decode(Set<RecurrenceDayOfWeek>.self, forKey: .daysOfWeek)
            self = .weekly(every: interval, days: days)
        case .monthly:
            let interval = try container.decode(Int.self, forKey: .every)
            let days = try container.decode(Set<Int>.self, forKey: .days)
            self = .monthly(every: interval, days: days)
        case .monthlyOrdinal:
            let interval = try container.decode(Int.self, forKey: .every)
            let ordinal = try container.decode(RecurrenceOrdinal.self, forKey: .monthlyOrdinal)
            let daysOfWeek = try container.decode(Set<RecurrenceDayOfWeek>.self, forKey: .daysOfWeek)
            self = .monthlyOrdinal(every: interval, onThe: ordinal, daysOfWeek)
        case .annually:
            let interval = try container.decode(Int.self, forKey: .every)
            let months = try container.decode(Set<RecurrenceMonth>.self, forKey: .months)
            let days = try container.decode(Set<Int>.self, forKey: .days)
            self = .annually(every: interval, in: months, days: days)
        case .annuallyOrdinal:
            let interval = try container.decode(Int.self, forKey: .every)
            let months = try container.decode(Set<RecurrenceMonth>.self, forKey: .months)
            let ordinal = try container.decode(RecurrenceOrdinal.self, forKey: .monthlyOrdinal)
            let daysOfWeek = try container.decode(Set<RecurrenceDayOfWeek>.self, forKey: .daysOfWeek)
            self = .annuallyOrdinal(every: interval, in: months, onThe: ordinal, daysOfWeek)
            
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(1, forKey: ._version)
        
        switch self {
        case .daily(let every):
            try container.encode(Repetition.daily, forKey: .baseType)
            try container.encode(every, forKey: .every)
        case .weekly(let every, let days):
            try container.encode(Repetition.weekly, forKey: .baseType)
            try container.encode(every, forKey: .every)
            try container.encode(days, forKey: .daysOfWeek)
        case .monthly(let every, let days):
            try container.encode(Repetition.monthly, forKey: .baseType)
            try container.encode(every, forKey: .every)
            try container.encode(days, forKey: .days)
        case .monthlyOrdinal(let every, let ordinal, let daysOfWeek):
            try container.encode(Repetition.monthlyOrdinal, forKey: .baseType)
            try container.encode(every, forKey: .every)
            try container.encode(ordinal, forKey: .monthlyOrdinal)
            try container.encode(daysOfWeek, forKey: .daysOfWeek)
        case .annually(let every, let monthSelection, let days):
            try container.encode(Repetition.annually, forKey: .baseType)
            try container.encode(every, forKey: .every)
            try container.encode(monthSelection, forKey: .months)
            try container.encode(days, forKey: .days)
        case .annuallyOrdinal(let every, let monthSelection, let ordinal, let daysOfWeek):
            try container.encode(Repetition.annuallyOrdinal, forKey: .baseType)
            try container.encode(every, forKey: .every)
            try container.encode(monthSelection, forKey: .months)
            try container.encode(ordinal, forKey: .monthlyOrdinal)
            try container.encode(daysOfWeek, forKey: .daysOfWeek)
        }
    }
}
