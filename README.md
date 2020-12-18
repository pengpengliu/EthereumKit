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

// let compressedPubkey = [0x02] + [UInt8](repeating: 0, count: 32)
let uncompressedPubkey = [UInt8](repeating: 0, count: 64)
let address = try! Address(uncompressedPubkey)
let checksummedWith0x = address.description 
```
