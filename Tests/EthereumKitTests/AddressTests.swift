//
//  Address.swift
//  
//
//  Created by Liu Pengpeng on 2020/12/16.
//

import XCTest
@testable import EthereumKit
import CryptoSwift

final class AddressTests: XCTestCase {
    func testUncompressed() {
        let pubkey = "54dec37f0858dd993798f8b31ba912eb3cee803ac4209596cc79c804a2f3c201c5c8c530ebd8af6cce71d1b2250dee29e660b1d10140226a7f5cbff46228de60"
        XCTAssertEqual("0xF97dd426AffA7950167A1796Cb807Db885E26131", try Address(Array(hex: pubkey)).description)
    }
    
    func testCompressed() {
        let pubkey = "0254dec37f0858dd993798f8b31ba912eb3cee803ac4209596cc79c804a2f3c201"
        XCTAssertEqual("0xF97dd426AffA7950167A1796Cb807Db885E26131", try Address(Array(hex: pubkey)).description)
    }

    static var allTests = [
        ("testUncompressed", testUncompressed),
        ("testCompressed", testCompressed),
    ]
}
