//
//  IvarGetters.swift
//  SwiftHooker
//
//  Created by Natheer on 12/07/2023.
//

import Foundation

/// Find a named iVar in a given Swift Class or NSObject based class
/// - Parameters:
///   - obj: The object to search in
///   - named: iVar name
/// - Returns: On success returns an `Ivar` or `nil` if not found
@_cdecl("SHGetNamedIvar")
public func GetNamedIvar(_ obj: Any, _ named: String) -> Ivar? {
    var count: UInt32 = 0
    var ivars: UnsafeMutablePointer<Ivar>?
    
    
    if let anyClass =  object_getClass(obj) {
        // Pure Swift Classes
        ivars = class_copyIvarList(anyClass, &count)
    } else if let anyObject = obj as? NSObject {
        // NSObject based
        ivars = class_copyIvarList(anyObject.classForCoder, &count)
    } else {
        return nil
    }
    
    if count == 0 {
        return nil
    }
    
    for i in 0..<count {
        let ivarName = String(cString: ivar_getName(ivars![Int(i)])!)
        if ivarName == named {
            return  ivars![Int(i)]
        }
    }
    return nil
}

/// Find a descriptor for a named iVar in a given Swift Class or NSObject based class
/// - Parameters:
///   - obj: The object to search in
///   - named: iVar name
/// - Returns: On success returns the descriptor
@_cdecl("SHGetNamedIvarDescriptor")
public func GetNamedIvarDescriptor(_ obj: Any, _ named: String) -> Any? {
    Mirror(reflecting: obj)
        .children
        .first(where: {$0.label == named})
}

@_cdecl("SHGetNamedIvarType")
public func GetNamedIvarType(_ obj: Any, _ named: String) -> Any? {
    Mirror(reflecting: obj)
        .children
        .first(where: {$0.label == named})?.value
}

// MARK: - iVar Getters per type
/// we have to do this beacuse the Generic getter doesn't work
@_cdecl("SHGetBoolIvarValue")
public func GetBoolIvarValue(obj: AnyObject, named: String) -> NSNumber? {
    let ivar = GetNamedIvar(obj, named)
    guard let ivar = ivar else { return nil }

    let objAddr = unsafeBitCast(obj, to: uintptr_t.self)
    let iVarOffset = UInt(ivar_getOffset(ivar))
    let ptr = UnsafeMutableRawPointer(bitPattern: objAddr + iVarOffset)
    let typedPointer = ptr?.assumingMemoryBound(to: Bool.self)

    guard let typedPointer = typedPointer else { return nil }
    
    return NSNumber(booleanLiteral: typedPointer.pointee)
}

@_cdecl("SHGetStringIvarValue")
public func GetStringIvarValue(for obj: AnyObject, named: String) -> String? {
    let ivar = GetNamedIvar(obj, named)
    guard let ivar = ivar else { return nil }

    let objAddr = unsafeBitCast(obj, to: uintptr_t.self)
    let iVarOffset = UInt(ivar_getOffset(ivar))
    let ptr = UnsafeMutableRawPointer(bitPattern: objAddr + iVarOffset)
    let typedPointer = ptr?.assumingMemoryBound(to: String.self)

    guard let typedPointer = typedPointer else { return nil }
    return typedPointer.pointee
}

@_cdecl("SHGetIntIvarValue")
public func GetIntIvarValue(for obj: AnyObject, named: String) -> NSNumber? {
    let ivar = GetNamedIvar(obj, named)
    guard let ivar = ivar else { return nil }

    let objAddr = unsafeBitCast(obj, to: uintptr_t.self)
    let iVarOffset = UInt(ivar_getOffset(ivar))
    let ptr = UnsafeMutableRawPointer(bitPattern: objAddr + iVarOffset)
    let typedPointer = ptr?.assumingMemoryBound(to: Int.self)

    guard let typedPointer = typedPointer else { return nil }
    return typedPointer.pointee as NSNumber
}
