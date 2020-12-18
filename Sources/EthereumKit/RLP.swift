//
//  RLP.swift
//  
//
//  Created by Liu Pengpeng on 2020/12/16.
//

import Foundation

public struct RLP {
    public static func encode(_ data: [UInt8]) -> [UInt8] {
        if (data.count == 1 && data.first! < 128) {
            return data
        } else {
            return encodeLength(length: data.count, offset: 128) + data
        }
    }
    
    public static func encode(_ data: [[UInt8]]) -> [UInt8] {
        var output = [UInt8]()
        for input in data {
            output += encode(input)
        }
        return encodeLength(length: output.count, offset: 192) + output
    }
    
    public static func decode(_ serialized: [UInt8]) throws -> [[UInt8]] {
        
        return []
    }
    
    static func encodeLength(length: Int, offset: Int) -> [UInt8] {
        if (length < 56) {
            return [UInt8(length + offset)]
        } else {
            return [UInt8(length)] + [UInt8(offset + 55 + length / 2)]
        }
    }
}
