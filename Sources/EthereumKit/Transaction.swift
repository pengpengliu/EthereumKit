//
//  Transaction.swift
//  
//
//  Created by Liu Pengpeng on 2020/12/16.
//

import Foundation
import Crypto101
import CryptoSwift

public struct Transaction {
    public enum Error: Swift.Error {
        case invalidSignature
    }
    
    public var nonce: [UInt8]
    public var gas: [UInt8]
    public var gasPrice: [UInt8]
    public var to: [UInt8]
    public var value: [UInt8]
    public var input: [UInt8]
    public var v: [UInt8]
    public var r: [UInt8]
    public var s: [UInt8]
    
    public init(nonce: [UInt8] = [], gas: [UInt8] = [], gasPrice: [UInt8] = [], to: [UInt8] = [], value: [UInt8] = [], input: [UInt8] = [], v: [UInt8] = [], r: [UInt8] = [], s: [UInt8] = []) throws {
        self.nonce = nonce == [0x0] ? [] : nonce
        self.gas = gas == [0x0] ? [] : gas
        self.gasPrice = gasPrice == [0x0] ? [] : gasPrice
        self.to = to == [0x0] ? [] : to
        self.value = value == [0x0] ? [] : value
        self.input = input == [0x0] ? [] : input
        self.v = v == [0x0] ? [] : v
        self.r = r == [0x0] ? [] : r
        self.s = s == [0x0] ? [] : s
    }
    
    public var serialized: [UInt8] {
        RLP.encode([nonce, gas, gasPrice, to, value, input, v, r, s])
    }
    
    public var hash: [UInt8] { RLP.encode([nonce, gas, gasPrice, to, value, input, v, r, s]).sha3(.keccak256) }
    
    public mutating func sign(with ecKey: [UInt8], chainId: UInt = 0) throws {
        var items = [nonce, gas, gasPrice, to, value, input]
        // About Chain ID: https://chainid.network/
        if chainId != 0 {
            items.append(contentsOf: [[UInt8(chainId)], [], [] ]) // EIP155
        }
        let raw = RLP.encode(items)
        print(raw.toHexString())
        let hash = raw.sha3(.keccak256)
        print(hash.toHexString())
        let signature = try ECC.Key(priv: ecKey, curve: .secp256k1).sign(hash: hash)

        self.r = signature.r
        self.s = signature.s
        guard let recId = signature.recoveryParam else {
            throw Error.invalidSignature
        }
        self.v = [UInt8(recId + (chainId == 0 ? 27 : (35 + 2 * chainId)))]
    }
}
