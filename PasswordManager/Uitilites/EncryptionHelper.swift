//
//  EncryptionHelper.swift
//  PasswordManager
//
//  Created by srisshar on 01/08/24.
//

import Foundation
import CommonCrypto

struct EncryptionHelper {
    // Define a 32-byte secret key and a 16-byte initialization vector (IV)
    private static let key = "your-secret-key-should-be-32-bytes-long!"
    private static let iv = "your-iv-16-bytes!"

    // Encrypts a string into Data using AES encryption
    static func encrypt(_ string: String) -> Data? {
        // Convert the string to Data
        guard let data = string.data(using: .utf8) else { return nil }
        // Call crypt function with encryption option
        return crypt(data: data, option: CCOperation(kCCEncrypt))
    }

    // Decrypts Data back into a string using AES decryption
    static func decrypt(_ data: Data) -> String? {
        // Call crypt function with decryption option
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        // Convert Data back to string
        return String(data: decryptedData, encoding: .utf8)
    }

    // Performs AES encryption or decryption
    private static func crypt(data: Data, option: CCOperation) -> Data? {
        // Define key length for AES256
        let keyLength = kCCKeySizeAES256
        // Calculate the required length for the output buffer
        var numBytesEncrypted: size_t = 0
        let cryptLength = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)

        // Perform the encryption/decryption
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                key.withCString { keyPtr in
                    iv.withCString { ivPtr in
                        CCCrypt(option,
                                CCAlgorithm(kCCAlgorithmAES128),            // AES encryption algorithm
                                CCOptions(kCCOptionPKCS7Padding),           // Padding option
                                keyPtr, keyLength,                          // Encryption key
                                ivPtr,                                      // Initialization vector
                                dataBytes.baseAddress, data.count,          // Input data
                                cryptBytes.baseAddress, cryptLength,        // Output buffer
                                &numBytesEncrypted)                         // Number of bytes encrypted/decrypted
                    }
                }
            }
        }

        // Ensure the encryption/decryption was successful
        guard cryptStatus == kCCSuccess else { return nil }
        // Trim the resulting data to the actual size of encrypted/decrypted data
        cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
        return cryptData
    }
}
