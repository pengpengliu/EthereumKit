//
//  RLP.swift
//  
//
//  Created by Liu Pengpeng on 2020/12/16.
//

import Foundation

public struct RLP {
    public static func encode(_ input: [UInt8]) -> [UInt8] {
        if (input.count == 1 && input.first! < 128) {
            return input
        } else {
            return encodeLength(length: input.count, offset: 128) + input
        }
    }
    
    public static func encode(_ data: [[UInt8]]) -> [UInt8] {
        var output = [UInt8]()
        for input in data {
            output += encode(input)
        }
        return encodeLength(length: output.count, offset: 192) + output
    }
    
    static func encodeLength(length: Int, offset: Int) -> [UInt8] {
        if (length < 56) {
            return [UInt8(length + offset)]
        } else {
            let lengthBytes = [UInt8(length)]
            return [UInt8(offset + 55 + lengthBytes.count)] + lengthBytes
        }
    }
}
