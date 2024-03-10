//
//  Array+Recurrable.swift
//  Recurrence
//
//  Created by David Monagle on 1/4/19.
//

import Foundation

/// An alias to allow easy creations of Recurrable stacks
public typealias RecurrableStack = Array<Recurrable>


// MARK: - Array Extension to make a stack of Recurrable objects Recurrable

extension Array : Recurrable where Element == Recurrable {
    public var intervalUnit: Interval.Unit {
        return last?.intervalUnit ?? .day
    }
    
    public func matches(date: Date, options: RecurrenceOptions) -> Bool {
        for selector in self {
            guard selector.matches(date: date, options: options) else { return false }
        }
        return true
    }
    
    public func first(for date: Date, options: RecurrenceOptions) -> Date? {
        var result = date
        for selector in self {
            guard let first = selector.first(for: result, options: options) else { return nil }
            result = first
        }
        return result
    }
    
    public func last(for date: Date, options: RecurrenceOptions) -> Date? {
        var result = date
        for selector in self {
            guard let last = selector.last(for: result, options: options) else { return nil }
            result = last
        }
        return result
    }
    
    public func date(before date: Date, options: RecurrenceOptions) -> Date? {
        return iterateBefore(stack: self, date: date, options: options)
    }
    
    public func date(after date: Date, options: RecurrenceOptions) -> Date? {
        return iterateAfter(stack: self, date: date, options: options)
    }

    private func iterateAfter(stack: [Recurrable], date: Date, options: RecurrenceOptions) -> Date? {
        var iStack = stack
        // Can't do anything if there are no selectors
        guard let selector = iStack.popLast() else { return nil }
        
        var checkDate = date
        repeat {
            // Only try a select if the stack above matches the current date
            if iStack.matches(date: checkDate, options: options) {
                // If there is a valid next date now, return it
                if let result = selector.date(after: checkDate, options: options) { return result }
            }
            // Iterate the stack above, if nil is returned then all options are exhausted and nil is returned
            guard
                let after = iterateAfter(stack: iStack, date: checkDate, options: options)
                else { return nil }
            if let next = selector.first(for: after, options: options) {
                if selector.matches(date: next, options: options) { return next }
                checkDate = next
            }
            else {
                checkDate = after
            }
        } while (true)
    }
    
    private func iterateBefore(stack: [Recurrable], date: Date, options: RecurrenceOptions) -> Date? {
        var iStack = stack
        // Can't do anything if there are no selectors
        guard let selector = iStack.popLast() else { return nil }
        
        var checkDate = date
        repeat {
            // Only try a select if the stack above matches the current date
            if iStack.matches(date: checkDate, options: options) {
                // If there is a valid next date now, return it
                if let result = selector.date(before: checkDate, options: options) { return result }
            }
            // Iterate the stack above, if nil is returned then all options are exhausted and nil is returned
            guard
                let before = iterateBefore(stack: iStack, date: checkDate, options: options)
                else { return nil }
            if let next = selector.last(for: before, options: options) {
                if selector.matches(date: next, options: options) { return next }
                checkDate = next
            }
            else {
                checkDate = before
            }
        } while (true)
    }
}

