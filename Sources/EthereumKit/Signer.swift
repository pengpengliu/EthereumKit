//
//  Signer.swift
//  
//
//  Created by Liu Pengpeng on 2022/4/24.
//

import Foundation
import CryptoSwift
import Crypto101

//"\u0019Ethereum Signed Message:\n"
let MESSAGE_PREFIX = Array<UInt8>(hex: "19457468657265756d205369676e6564204d6573736167653a0a")

public struct Signer {
    var privateKey: [UInt8]
    
    func signPrefixedMessage(_ msg: String) -> [UInt8] {
        let messageBytes = Array<UInt8>(msg.utf8)
        
        let messageLength = String(messageBytes.count)
        
        let hash = (MESSAGE_PREFIX + Array<UInt8>(messageLength.utf8) + messageBytes).sha3(.keccak256)
        
        let signature = try! ECC.Key(priv: privateKey, curve: .secp256k1).sign(hash: hash)
        
        return signature.r + signature.s + [UInt8(signature.recoveryParam! + 27)]
    }
}
