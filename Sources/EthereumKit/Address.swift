//
//  Address.swift
//  
//
//  Created by Liu Pengpeng on 2020/12/16.
//

import Foundation
import Crypto101
import CryptoSwift
import secp256k1

public struct Address: CustomStringConvertible {
    public enum Error: Swift.Error {
        case invalidAddress
        case invalidPublicKey
        case invalidPrivateKey
        case invalidSignature
        case invalidRecoveryID
        case internalError
    }
    
    var bytes: [UInt8]
    
    public init(_ content: String) throws {
        guard content.range(of: #"^0x[a-fA-F0-9]{64}$"#, options: .regularExpression) != nil else {
            throw Error.invalidAddress
        }
        bytes = Array(hex: content)
    }
    
    public init(_ pubkey: [UInt8]) throws {
        var uncompressedPubkey = pubkey
        if (pubkey.count != 64) {
            uncompressedPubkey = try Address.decompressPublicKey(pubkey)
        }
        bytes = uncompressedPubkey.sha3(.keccak256).suffix(20)
    }
    
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md
    public var description: String {
        let address = bytes.toHexString()
        let hash = address.data(using: .ascii)!.sha3(.keccak256).toHexString()
        return "0x" + zip(address, hash)
            .map { a, h -> String in
                switch (a, h) {
                case ("0", _), ("1", _), ("2", _), ("3", _), ("4", _), ("5", _), ("6", _), ("7", _), ("8", _), ("9", _):
                    return String(a)
                case (_, "8"), (_, "9"), (_, "a"), (_, "b"), (_, "c"), (_, "d"), (_, "e"), (_, "f"):
                    return String(a).uppercased()
                default:
                    return String(a).lowercased()
                }
            }
            .joined()
    }
    
    static func decompressPublicKey(_ pubkey: [UInt8]) throws -> [UInt8] {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
        defer {
            secp256k1_context_destroy(ctx)
        }
        var cPubkey = secp256k1_pubkey()
        var uncompressedKeyLen = 65
        var uncompressedPubkey = [UInt8](repeating: 0, count: uncompressedKeyLen)

        guard secp256k1_ec_pubkey_parse(ctx, &cPubkey, pubkey, pubkey.count) == 1,
            secp256k1_ec_pubkey_serialize(ctx, &uncompressedPubkey, &uncompressedKeyLen, &cPubkey, UInt32(SECP256K1_EC_UNCOMPRESSED)) == 1 else {
            throw Error.internalError
        }
        uncompressedPubkey.remove(at: 0)
        return uncompressedPubkey
    }
}

extension Address: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.bytes == rhs.bytes
    }
}
