//
//  NSObject+Reflection.swift
//  SwiftHooker
//
//  Created by Natheer on 09/07/2023.
//

import Foundation

@objc(SHIvarsSettersHelpers)
public extension NSObject {
    /// Overrides an iVar of type Bool with a new Value
    /// - Parameters:
    ///   - name: iVar named to override
    ///   - newValue: new value to assign
    /// - Returns: A best guess scenario if what happened
    @objc(SHSetBoolIvarNamed:newValue:)
    @discardableResult
    func SHSetBoolIvar(_ name: String, _ newValue: Bool) -> Bool {
        SetIvar(for: self, named: name, newValue: newValue)
    }

    /// Overrides an iVar of type String with a new Value
    /// - Parameters:
    ///   - name: iVar named to override
    ///   - newValue: new value to assign
    /// - Returns: A best guess scenario if what happened
    @objc(SHSetStringIvarNamed:newValue:)
    @discardableResult
    func SHSetStringIvar(_ name: String, _ newValue: String) -> Bool {
        SetIvar(for: self, named: name, newValue: newValue)
    }

    /// Overrides an iVar of type Int with a new Value
    /// - Parameters:
    ///   - name: iVar named to override
    ///   - newValue: new value to assign
    /// - Returns: A best guess scenario if what happened
    @objc(SHSetIntIvarNamed:newValue:)
    @discardableResult
    func SHSetIntIvar(_ name: String, _ newValue: Int) -> Bool {
        SetIvar(for: self, named: name, newValue: newValue)
    }

    /// Overrides an iVar of type Float with a new Value
    /// - Parameters:
    ///   - name: iVar named to override
    ///   - newValue: new value to assign
    /// - Returns: A best guess scenario if what happened
    @objc(SHSetFloatIvarNamed:newValue:)
    @discardableResult
    func SHSetFloatIvar(_ name: String, _ newValue: Float) -> Bool {
        SetIvar(for: self, named: name, newValue: newValue)
    }
}

@objc(SHIvarsGettersHelpers)
public extension NSObject {
    /// Returns a description of the named iVar
    /// - Parameter name: iVar name to find
    /// - Returns: description of the iVar
    @objc func SHGetIvarDescriptor(_ name: String) -> Any? {
        Mirror(reflecting: self)
            .children
            .first(where: {$0.label == name})
    }

    /// Gets the value of a Bool iVar
    /// - Parameters:
    ///   - name: iVar name to read
    /// - Returns: -1 if an error, else the `Bool` value
    @objc(SHGetBoolIvarValueNamed:)
    func SHGetBoolIvarValue(_ name: String) -> NSNumber {
        let res = SwiftHooker.GetBoolIvarValue(obj: self, named: name)
        guard let res = res else { return -1 }
        return res
    }

    /// Gets the value of a String iVar
    /// - Parameters:
    ///   - name: iVar named to override
    /// - Returns: The String or nil
    @objc(SHGetStringIvarValueNamed:)
    @discardableResult
    func SHGetStringIvarValue(_ name: String) -> String? {
        SwiftHooker.GetStringIvarValue(for: self, named: name)
    }

    /// Gets the value of a Int iVar
    /// - Parameters:
    ///   - name: iVar named to override
    /// - Returns: -1 if an error, else the `Int` value
    @objc(SHGetIntIvarValueNamed:)
    @discardableResult
    func SHGetIntIvarValue(_ name: String) -> NSNumber? {
        let res = SwiftHooker.GetIntIvarValue(for: self, named: name)
        guard let res = res else { return nil }
        return res
    }
}
