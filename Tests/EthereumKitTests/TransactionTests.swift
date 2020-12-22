//
//  TransactionTests.swift
//  
//
//  Created by Liu Pengpeng on 2020/12/21.
//

import XCTest
@testable import EthereumKit
import CryptoSwift

final class TransactionTests: XCTestCase {
    let nonce = Array<UInt8>(hex: "0x0")
    let gas = Array<UInt8>(hex: "0x131794b400")
    let gasPrice = Array<UInt8>(hex: "0xbeab")
    let to = Array<UInt8>(hex: "0x01904b5ee633b15f252879c9c0756416adee7f03")
    let value = Array<UInt8>(hex: "0x0")
    let input = Array<UInt8>(hex: "0x0")
    
    func testUnsignedTransaction() {
        let transaction = try! Transaction(nonce: nonce, gas: gas, gasPrice: gasPrice, to: to, value: value, input: input)
        let serialized = "e48085131794b40082beab9401904b5ee633b15f252879c9c0756416adee7f038080808080"
        XCTAssertEqual(transaction.serialized.toHexString(), serialized)
    }
    
    func testSignedTransaction() {
        var transaction = try! Transaction(nonce: nonce, gas: gas, gasPrice: gasPrice, to: to, value: value, input: input)
        let ecKey = Array<UInt8>(hex: "0xe3d5ef38fe3e5a9b896bac3b1331c3691efe26b13c4f40a036e6aabab38ecbab")
        try? transaction.sign(with: ecKey)
        let serialized = "f8648085131794b40082beab9401904b5ee633b15f252879c9c0756416adee7f0380801ca068280215d8ec140e65d0f6c7d630fd9402dae3b8ec3f94b99a1086f35c2f9a2fa0038eb61e7bed120b08a1ea2af5234fef182e006f8bd1edfe8ac91047d0c7869a"
        XCTAssertEqual(transaction.serialized.toHexString(), serialized)
        
        try? transaction.sign(with: ecKey, chainId: 1)
        let serializedWithChainId = "f8648085131794b40082beab9401904b5ee633b15f252879c9c0756416adee7f03808025a02c756b0ad3ca1296afd15a72ecea0647e6a00d8ba2ad3b8a9b73447097d1bd53a058ebca8ff8d33f110104c9b42e928163e4996520047104582d8701bcb75dde08"
        XCTAssertEqual(transaction.serialized.toHexString(), serializedWithChainId)
    }

    static var allTests = [
        ("testUnsignedTransaction", testUnsignedTransaction),
        ("testSignedTransaction", testSignedTransaction),
    ]
}
