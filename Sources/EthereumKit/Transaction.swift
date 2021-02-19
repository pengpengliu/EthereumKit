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
    public var gasPrice: [UInt8]
    public var gas: [UInt8]
    public var to: [UInt8]
    public var value: [UInt8]
    public var input: [UInt8]
    public var v: [UInt8]
    public var r: [UInt8]
    public var s: [UInt8]
    
    public init(_ serialized: [UInt8]) throws {
        let decoded: [[UInt8]] = RLP.decode(serialized)
        self.nonce = decoded[0]
        self.gasPrice = decoded[1]
        self.gas = decoded[2]
        self.to = decoded[3]
        self.value = decoded[4]
        self.input = decoded[5]
        self.v = decoded[6]
        self.r = decoded[7]
        self.s = decoded[8]
    }
    
    public init(nonce: [UInt8] = [], gasPrice: [UInt8] = [], gas: [UInt8] = [], to: [UInt8] = [], value: [UInt8] = [], input: [UInt8] = [], v: [UInt8] = [], r: [UInt8] = [], s: [UInt8] = []) throws {
        self.nonce = nonce == [0x0] ? [] : nonce
        self.gasPrice = gasPrice == [0x0] ? [] : gasPrice
        self.gas = gas == [0x0] ? [] : gas
        self.to = to == [0x0] ? [] : to
        self.value = value == [0x0] ? [] : value
        self.input = input == [0x0] ? [] : input
        self.v = v == [0x0] ? [] : v
        self.r = r == [0x0] ? [] : r
        self.s = s == [0x0] ? [] : s
    }
    
    public var serialized: [UInt8] {
        RLP.encode([nonce, gasPrice, gas, to, value, input, v, r, s])
    }
    
    public var hash: [UInt8] { RLP.encode([nonce, gasPrice, gas, to, value, input, v, r, s]).sha3(.keccak256) }
    
    public mutating func sign(with ecKey: [UInt8], chainId: UInt = 0) throws {
        var items = [nonce, gasPrice, gas, to, value, input]
        // About Chain ID: https://chainid.network/
        if chainId != 0 {
            items.append(contentsOf: [[UInt8(chainId)], [], [] ]) // EIP155
        }
        let raw = RLP.encode(items)
        let hash = raw.sha3(.keccak256)
        let signature = try ECC.Key(priv: ecKey, curve: .secp256k1).sign(hash: hash)

        self.r = signature.r
        self.s = signature.s
        guard let recId = signature.recoveryParam else {
            throw Error.invalidSignature
        }
        self.v = [UInt8(recId + (chainId == 0 ? 27 : (35 + 2 * chainId)))]
    }
}
