//
//  File.swift
//  
//
//  Created by Rosliakov Evgenii on 31.08.2021.
//

//public func ~= <Value>(
//    pattern: KeyPath<Value, Bool>,
//    value: Value
//) -> Bool {
//    value[keyPath: pattern]
//}

public func ~= <Value>(
    pattern: (Value) -> Bool,
    value: Value
) -> Bool {
    pattern(value)
}
