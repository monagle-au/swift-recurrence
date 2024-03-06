//
//  RecurrenceSequence.swift
//  Recurrence
//
//  Created by David Monagle on 30/3/19.
//
import Foundation

/// Provides a sequence accessor for any Recurrable which conforms to Sequence
public extension Recurrable {
    /// Returns a RecurrenceSequence conforming to Sequence to allow iteration of matching dates
    func sequence(options: RecurrenceOptions, starting: Date? = nil, ending: Date? = nil, limit: Int? = nil) -> RecurrenceSequence {
        return RecurrenceSequence(self, options: options, starting: starting, ending: ending, limit: limit)
    }
}

public struct RecurrenceSequence : Sequence {
    public let recurrable: Recurrable
    public let options: RecurrenceOptions
    public let starting: Date?
    public let ending: Date?
    public let limit: Int?
    
    public init(_ recurrable : Recurrable, options: RecurrenceOptions, starting: Date? = nil, ending: Date? = nil, limit: Int? = nil) {
        self.recurrable = recurrable
        self.options = options
        self.starting = starting
        self.ending = ending
        self.limit = limit
    }
    
    public __consuming func makeIterator() -> RecurrenceIterator {
        return RecurrenceIterator(self)
    }
    
    public func firstDate(after date: Date? = nil) -> Date? {
        return recurrable.first(from: date, options: options)
    }
}

public struct RecurrenceIterator : IteratorProtocol {
    public typealias Element = Date
    let sequence: RecurrenceSequence
    var last: Date? = nil
    var count: Int = 0
    
    public init(_ sequence: RecurrenceSequence) {
        self.sequence = sequence
    }
    
    private lazy var iteratorEndDate : Date? = {
        return [
            sequence.ending,
            sequence.options.endDate
        ].compactMap { $0 }.min()
    }()
    
    private lazy var iteratorStartDate : Date? = {
        return [
            sequence.starting,
            sequence.options.startDate
        ].compactMap { $0 }.max()
    }()
    
    public mutating func next() -> Date? {
        count += 1
        if let limit = sequence.limit, count > limit { return nil }
        
        if last == nil {
            last = sequence.firstDate(after: iteratorStartDate)
        }
        else {
            last = sequence.recurrable.date(after: last!, options: sequence.options)
        }
        
        if last == nil { return nil }
        
        if let endDate = iteratorEndDate, last! >= endDate { return nil }
        
        return last
    }
}
