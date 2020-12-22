//
//  RLPTests.swift
//  
//
//  Created by Liu Pengpeng on 2020/12/18.
//

import XCTest
@testable import EthereumKit
import CryptoSwift

final class RLPTests: XCTestCase {
    func testEncode() {
        XCTAssertEqual([0x80], RLP.encode([UInt8]()))
        XCTAssertEqual([0xc1, 0x80], RLP.encode([[UInt8]()]))
        XCTAssertEqual([0x85, 0x13, 0x17, 0x94, 0xb4, 0x00], RLP.encode([0x13, 0x17, 0x94, 0xb4, 0x00]))
    }
    
    static var allTests = [
        ("testEncode", testEncode),
    ]
}
