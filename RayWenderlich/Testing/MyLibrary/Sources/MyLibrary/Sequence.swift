//
//  File.swift
//  
//
//  Created by Rosliakov Evgenii on 31.08.2021.
//

extension Sequence {
    var first: Element? { self.first { _ in true } }
}

extension Sequence where Element: AdditiveArithmetic {
    var sum: Element? {
        guard first != nil else {
            return nil
        }
        
        return reduce(.zero, +)
    }
}
