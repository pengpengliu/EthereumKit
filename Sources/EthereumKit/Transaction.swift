//
//  Transaction.swift
//  
//
//  Created by Liu Pengpeng on 2020/12/16.
//

import Foundation

public struct Transaction {
    public var serialized: [UInt8]
    
    public var nonce: [UInt8] { (try? RLP.decode(serialized)[0]) ?? [] }
    public var gasLimit: [UInt8] { (try? RLP.decode(serialized)[1]) ?? [] }
    public var gasPrice: [UInt8] { (try? RLP.decode(serialized)[2]) ?? [] }
    public var to: [UInt8] { (try? RLP.decode(serialized)[3]) ?? [] }
    public var value: [UInt8] { (try? RLP.decode(serialized)[4]) ?? [] }
    public var data: [UInt8] { (try? RLP.decode(serialized)[5]) ?? [] }
    public var v: [UInt8] { (try? RLP.decode(serialized)[6]) ?? [] }
    public var r: [UInt8] { (try? RLP.decode(serialized)[7]) ?? [] }
    public var s: [UInt8] { (try? RLP.decode(serialized)[8]) ?? [] }
    
    public init(_ serialized: [UInt8]) throws {
        self.serialized = serialized
    }
}


// 1600 * 6.5 * 4 = 41600
// 100000 / 6.5 / 5 = 3000
// 100000 / 6.5 / 2000 = 7.6
