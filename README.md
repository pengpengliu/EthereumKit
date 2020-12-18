# EthereumKit

Install
-------

### SwiftPM

```
https://github.com/pengpengliu/EthereumKit.git
```

Usage
-------

```swift
import EthereumKit

// let uncompressedPubkey = [0x02] + [UInt8](repeating: 0, count: 64)
let compressedPubkey = [0x02] + [UInt8](repeating: 0, count: 32)
let address = try! Address(compressedPubkey)
let checksummedWith0x = address.description 
```
