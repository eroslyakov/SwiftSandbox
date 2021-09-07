import XCTest
import MyLibrary

final class BoolInitTestCase: XCTestCase {
    func test_validBits() throws {
        let boolFromFalse = try XCTUnwrap(Bool(bit: 0))
        let boolFromTrue = try XCTUnwrap(Bool(bit: 1 as Int16))
        
        XCTAssert(boolFromTrue)
        XCTAssertFalse(boolFromFalse)
    }
    
    func test_invalidBits() {
        XCTAssertNil(Bool(bit: -1))
        XCTAssertNil(Bool(bit: 2 as Int32))
    }
    
    func test_DataBytes() {
        let data = Data(0...2)
        let falseByte: UInt8 = data[0]
        let trueByte: UInt8 = data[1]
        let nilByte = data[2]
        
        XCTAssert(try XCTUnwrap(Bool(bit: trueByte)))
        XCTAssertFalse(try XCTUnwrap(Bool(bit: falseByte)))
        XCTAssertNil(Bool(bit: nilByte))
    }
}
