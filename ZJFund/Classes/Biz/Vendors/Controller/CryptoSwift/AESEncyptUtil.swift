//
//  AESEncyptUtil.swift
//  ZJFund
//
//  Created by Jercan on 2024/3/27.
//

import Foundation
import CryptoSwift

// 注释快捷键：Command + Option + /
// https://blog.csdn.net/Cheung1992/article/details/132752733

class AESEncyptUtil {

    /// AES-ECB 在进行AES加密时，CryptoSwift会根据密钥的长度自动选择对应的加密算法（AES128，AES192，AES256）
    /// - Parameters:
    ///   - encryptText: 需要加密的数据
    ///   - key: 密钥：AES-128 = 16 BYTES，AES-192 = 24 bytes，AES-256 = 32 bytes，不够位数，则自动尾部补0，直到自动补齐至加密位数
    /// - Returns: 加密后返回的数据
    static func encrypt_AES_ECB(encryptText: String, key: String) throws -> String {
        // 使用AES_ECB模式
        let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: AES.blockSize), blockMode: ECB())
        // 开始加密
        let encrypted = try aes.encrypt(encryptText.bytes)
        // 将加密结果转成base64形式
        return encrypted.toBase64()
    }
    
    
    /// AES-ECB 在进行AES加密时，CryptoSwift会根据密钥的长度自动选择对应的加密算法（AES128，AES192，AES256）
    /// - Parameters:
    ///   - encryptData: 需要加密的数据
    ///   - key: 密钥：AES-128 = 16 BYTES，AES-192 = 24 bytes，AES-256 = 32 bytes，不够位数，则自动尾部补0，直到自动补齐至加密位数
    /// - Returns: 加密后返回的数据
    static func encryptData_AES_ECB(encryptData: Data, key: String) throws -> Data {
        // 使用AES_ECB模式
        let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: AES.blockSize), blockMode: ECB())
        // 开始加密
        let encrypted = try aes.encrypt(encryptData.bytes)
        // 将加密结果转成base64形式
        return Data(encryptData)
    }
    
    
    /// AES-ECB解密
    /// - Parameters:
    ///   - decryptText: 需要解密的数据
    ///   - key: 密钥
    /// - Returns: 解密后的数据
    static func decrypt_AES_ECB(decryptText: String, key: String) throws -> String {
        let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: AES.blockSize), blockMode: ECB())
        let decrypted = try decryptText.decryptBase64ToString(cipher: aes)
        return decrypted
    }
    
    /// AES_CBC 加密
    /// - Parameters:
    ///   - encryptText: 加密数据
    ///   - key: 密钥
    ///   - ivs: 密钥偏移量
    /// - Returns: 加密后的数据
    static func encrypt_AES_CBC(encryptText: String, key: String, ivs: String) throws -> String {
        // 使用AES_CBC模式
        let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: AES.blockSize), blockMode: CBC(iv: ivs.bytes))
        // 开始加密
        let encrypted = try aes.encrypt(encryptText.bytes)
        // 将加密结果转成base64形式
        return encrypted.toBase64()
    }
    
    
    /// AES_CBC 解密
    /// - Parameters:
    ///   - decryptText: 需要解密数据
    ///   - key: 密钥
    ///   - ivs: 密钥偏移量
    /// - Returns: 解密后数据
    static func decrypt_AES_CBC(decryptText: String, key: String, ivs: String) throws -> String {
        // 使用AES_CBC模式
        let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: AES.blockSize), blockMode: CBC(iv: ivs.bytes))
        // 开始解密 从加密后的base64字符串解密
        let decrypted = try decryptText.decryptBase64ToString(cipher: aes)
        return decrypted
    }
    
    /// AES_GCM 加密
    ///  - Parameters:
    ///    - encryptText: 需要加密的数据
    ///    - key: 密钥
    ///    - ivs: 密钥偏移量
    ///  - Returns: 加密后的数据
    static func encrypt_AES_GCM(encryptText: Array<UInt8>, key: Array<UInt8>, ivs: Array<UInt8>) throws -> Array<UInt8> {
        let gcm = GCM(iv: ivs, mode: .combined)
        let aes = try AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try aes.encrypt(encryptText)
        _ = gcm.authenticationTag
        return encrypted
    }
    
    
    /// AES_GCM 解密
    /// - Parameters:
    ///   - decryptText: 需要解密的数据
    ///   - key: 密钥
    ///   - ivs: 密钥偏移量
    /// - Returns: 解密后的数据
    static func decrypt_AES_GCM(decryptText: Array<UInt8>, key: Array<UInt8>, ivs: Array<UInt8>) throws -> Array<UInt8> {
        let gcm = GCM(iv: ivs, mode: .combined)
        let aes = try AES(key: key, blockMode: gcm, padding: .noPadding)
        return try aes.decrypt(decryptText)
    }
    
}

