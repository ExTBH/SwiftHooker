//
//  IvarSetters.swift
//  SwiftHooker
//
//  Created by Natheer on 11/07/2023.
//

import Foundation


/// Sets a new value for a given named iVar
/// - Parameters:
///   - obj: The object containing the iVar
///   - named: The iVar name
///   - newValue: The new value to Assign
/// - Returns: returns `false` if the iVar can't be found or if the iVar pointer can't be casted.
@discardableResult
public func SetIvar<T>(for obj: AnyObject, named: String, newValue: T) -> Bool {
    guard let iVar = GetNamedIvar(obj, named) else { return false}
    return SetIvar(for: obj, iVar: iVar, newValue: newValue)
}

/// Sets a new value for a given iVar
/// - Parameters:
///   - obj: The object containing the iVar
///   - iVar: The iVar
///   - newValue: The new value to Assign
/// - Returns: returns `false` if the iVar pointer can't be casted.
@discardableResult
public func SetIvar<T>(for obj: AnyObject, iVar: Ivar, newValue: T) -> Bool {
    let objAddr = unsafeBitCast(obj, to: uintptr_t.self)
    let iVarOffset = UInt(ivar_getOffset(iVar))
    let ptr = UnsafeMutableRawPointer(bitPattern: objAddr + iVarOffset)
    let typedPointer = ptr?.assumingMemoryBound(to: T.self)
    
    guard let typedPointer = typedPointer else { return false }
    typedPointer.pointee = newValue
    return true
}



// MARK: - C Ivar Setters

/// Overrides an iVar of type Bool with a new Value
/// - Parameters:
///   - obj: The object caontaining the iVar
///   - name: iVar named to override
///   - newValue: new value to assign
/// - Returns: A best guess scenario if what happened
@discardableResult
@_cdecl("SHSetBoolIvar")
public func SetBoolIvar(_ obj: AnyObject,_ name: String, _ newValue: Bool) -> Bool {
    return SetIvar(for: obj, named: name, newValue: newValue)
}

/// Overrides an iVar of type String with a new Value
/// - Parameters:
///   - obj: The object caontaining the iVar
///   - name: iVar named to override
///   - newValue: new value to assign
/// - Returns: A best guess scenario if what happened
@discardableResult
@_cdecl("SHSetStringIvar")
public func SetStringIvar(_ obj: AnyObject,_ name: String, _ newValue: String) -> Bool {
    return SetIvar(for: obj, named: name, newValue: newValue)
}

/// Overrides an iVar of type Int with a new Value
/// - Parameters:
///   - obj: The object caontaining the iVar
///   - name: iVar named to override
///   - newValue: new value to assign
/// - Returns: A best guess scenario if what happened
@discardableResult
@_cdecl("SHSetIntIvar")
public func SetIntIvar(_ obj: AnyObject,_ name: String, _ newValue: Int) -> Bool {
    return SetIvar(for: obj, named: name, newValue: newValue)
}

/// Overrides an iVar of type Float with a new Value
/// - Parameters:
///     - obj: The object caontaining the iVar
///   - name: iVar named to override
///   - newValue: new value to assign
/// - Returns: A best guess scenario if what happened
@discardableResult
@_cdecl("SHSetFloatIvar")
public func SetFloatIvar(_ obj: AnyObject, _ name: String, _ newValue: Float) -> Bool {
    return SetIvar(for: obj, named: name, newValue: newValue)
}
