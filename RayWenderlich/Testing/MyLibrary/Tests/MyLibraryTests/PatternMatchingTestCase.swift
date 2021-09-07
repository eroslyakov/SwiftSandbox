//
//  File.swift
//  
//
//  Created by Rosliakov Evgenii on 31.08.2021.
//

import XCTest
@testable import MyLibrary

final class PatternMatchingTestCase: XCTestCase {
    
    func test_Character() {
        let g: Character = "g"
        switch g {
        case \.isNumber, \.isHexDigit:
            XCTFail()
        case \.isLetter:
            break
        default:
            XCTFail()
        }
    }
    
    func test_Doubles() {
        switch 1.0 {
        case \.isZero,
             [2, 100, -0.3].contains,
             { $0 != 1 }:
            XCTFail()
        case \.isInteger:
            break
        default:
            XCTFail()
        }
    }
}
