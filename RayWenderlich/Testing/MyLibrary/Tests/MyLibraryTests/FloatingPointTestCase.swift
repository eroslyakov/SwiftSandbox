//
//  File.swift
//  
//
//  Created by Rosliakov Evgenii on 31.08.2021.
//

import XCTest
@testable import MyLibrary

final class FloatingPointTestCase: XCTestCase {
    func test_isInteger() {
        XCTAssert(13.0.isInteger) // same as XCTAssertTrue
        XCTAssertFalse(CGFloat(3.745).isInteger)
    }
}
