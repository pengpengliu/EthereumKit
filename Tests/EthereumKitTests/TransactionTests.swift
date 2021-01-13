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
    let gas = Array<UInt8>(hex: "0xbeab")
    let gasPrice = Array<UInt8>(hex: "0x131794b400")
    let to = Array<UInt8>(hex: "0x01904b5ee633b15f252879c9c0756416adee7f03")
    let value = Array<UInt8>(hex: "0x0")
    let input = Array<UInt8>(hex: "0x0")
    
    func testUnsignedTransaction() {
        let transaction = try! Transaction(nonce: nonce, gasPrice: gasPrice, gas: gas, to: to, value: value, input: input)
        let serialized = "e48085131794b40082beab9401904b5ee633b15f252879c9c0756416adee7f038080808080"
        XCTAssertEqual(transaction.serialized.toHexString(), serialized)
    }
    
    func testSignedTransaction() {
        var transaction = try! Transaction(nonce: nonce, gasPrice: gasPrice, gas: gas, to: to, value: value, input: input)
        let ecKey = Array<UInt8>(hex: "0xe3d5ef38fe3e5a9b896bac3b1331c3691efe26b13c4f40a036e6aabab38ecbab")
        try? transaction.sign(with: ecKey)
        let serialized = "f8648085131794b40082beab9401904b5ee633b15f252879c9c0756416adee7f0380801ca068280215d8ec140e65d0f6c7d630fd9402dae3b8ec3f94b99a1086f35c2f9a2fa0038eb61e7bed120b08a1ea2af5234fef182e006f8bd1edfe8ac91047d0c7869a"
        XCTAssertEqual(transaction.serialized.toHexString(), serialized)
        
        try? transaction.sign(with: ecKey, chainId: 1)
        let serializedWithChainId = "f8648085131794b40082beab9401904b5ee633b15f252879c9c0756416adee7f03808025a02c756b0ad3ca1296afd15a72ecea0647e6a00d8ba2ad3b8a9b73447097d1bd53a058ebca8ff8d33f110104c9b42e928163e4996520047104582d8701bcb75dde08"
        XCTAssertEqual(transaction.serialized.toHexString(), serializedWithChainId)
    }
    
    func testBuildTransaction() {
        // Test Account:
        // Address: 0xdfe1093b1c8d74e1a347c2b086ef9181215d2f2c
        // Private Key: 0x9c2ace3d1aaaa972123f64968ff76e568fadc741fd2841c6c43a647d3702a5a5
        let key = [UInt8](hex: "0x9c2ace3d1aaaa972123f64968ff76e568fadc741fd2841c6c43a647d3702a5a5")
        
        // Step1: Building
        // 0xdfe1093b1c8d74e1a347c2b086ef9181215d2f2c -> 0x5a3c53ba403528e95a174120e3ac16a0d1191aad 0.1
        let tx1 = try! Transaction(to: [UInt8](hex: "0x5a3c53ba403528e95a174120e3ac16a0d1191aad"), value: [UInt8](hex: "0x016345785d8a0000"))
        // Step2: Packing
        var tx2 = try! Transaction(tx1.serialized)
        tx2.nonce = [0x1] // 1
        tx2.gas = [UInt8](hex: "0x5208") // 21000
        tx2.gasPrice = [UInt8](hex: "0x0ba43b7400") // 50 Gwei
        
        try! tx2.sign(with: key, chainId: 42)
        XCTAssertEqual("36951ada7a9c2b8519905e4e76514948eb233ceb8a8c557ec9d0a7b2316f4a47", tx2.hash.toHexString())
        // print(tx2.serialized.toHexString())
        XCTAssertEqual(tx2.serialized.toHexString(), "f86c01850ba43b7400825208945a3c53ba403528e95a174120e3ac16a0d1191aad88016345785d8a00008078a0b8616a5c3cd1fe5588e8df2b394de27acbee361a2bd9d01bd656860b5582bc88a019d73b0b23327d92f640fb33180a16d85a50ef80f960b8e66ad59ae50f10e051")
    }

    static var allTests = [
        ("testUnsignedTransaction", testUnsignedTransaction),
        ("testSignedTransaction", testSignedTransaction),
    ]
}
