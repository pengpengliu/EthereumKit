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
    
    public static func decode(_ input: [UInt8]) -> [UInt8] {
        return _decode(input).0 as! [UInt8]
    }
    
    public static func decode(_ input: [UInt8]) -> [[UInt8]] {
        return _decode(input).0 as! [[UInt8]]
    }
    
    private static func _decode(_ input: [UInt8]) -> ([Any], [UInt8]) {
        var length: Int
        var data: [UInt8]
        var innerRemainder = [UInt8]()
        var decoded = [Any]()
        let firstByte = input[0]
        if (firstByte <= 0x7f) {
            // a single byte whose value is in the [0x00, 0x7f] range, that byte is its own RLP encoding.
            return (Array(input[0..<1]), Array(input[1...]))
        }
        else if (firstByte <= 0xb7) {
            // string is 0-55 bytes long. A single byte with value 0x80 plus the length of the string followed by the string
            // The range of the first byte is [0x80, 0xb7]
            length = Int(firstByte - 0x7f)
            // set 0x80 null to 0
            if (firstByte == 0x80) {
                data = []
            } else {
                data = Array(input[1..<length])
            }
            if (length == 2 && data[0] < 0x80) {
                // Error: invalid rlp encoding: byte must be less 0x80
            }
            return (data, Array(input[length...]))
        }
        else if (firstByte <= 0xf7) {
            // a list between  0-55 bytes long
            length = Int(firstByte - 0xbf)
            innerRemainder = Array(input[1..<length])
            while innerRemainder.count != 0 {
                let d = _decode(innerRemainder)
                decoded.append(d.0)
                innerRemainder = d.1
            }
            return (decoded, Array(input[length...]))
        }
        return (decoded, innerRemainder)
    }
}
