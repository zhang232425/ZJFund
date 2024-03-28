//
//  CryptoSwiftVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/3/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt
import CryptoSwift
import CryptoKit

/**
 加密简介：
 https://blog.csdn.net/qq_21046965/category_11302661.html
 */

class CryptoSwiftVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("Test", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
}

private extension CryptoSwiftVC {
    
    func setupViews() {
        
        testBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(30.auto)
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribeNext(weak: self, CryptoSwiftVC.testClick).disposed(by: disposeBag)
        
    }
    
}

private extension CryptoSwiftVC {
    
    func testClick(_: Void) {
        if #available(iOS 13.0, *) {
            self.aes()
        }
    }
    
}

private extension CryptoSwiftVC {
    
    // MARK: - Data 与字节数组（bytes）间的转换
    func dataBytes1() {
        
        // bytes转Data
        let data = Data(bytes: [0x01, 0x02, 0x03, 0x04])
        // Data转bytes
        let bytes = data.bytes
        
        print("bytes = ", bytes)
        
    }
    
    // MARK: - 十六进制编码
    func dataBytes2() {
        
        // 使用十六进制编码的形式建立字节数组
        let bytes = Array<UInt8>(hex: "0x010203")
        print("bytes = ", bytes)
        
        // 将字节数组转换为对应的十六进制编码
        let hex = bytes.toHexString()
        print("hex = ", hex)
        
    }
    
    // MARK: - 使用字符串生成字节数组
    func dataBytes3() {
        
        let bytes: Array<UInt8> = "123456".bytes
        print("bytes = ", bytes)
        
    }
    
    // MARK: - 字节数组的 base64 转换
    func dataBytes4() {
        
        // 字节数组的base64编码
        let bytes: [UInt8] = [1, 2, 3, 4, 5]
        let base64String1 = bytes.toBase64()
        print("base64String1 = ", base64String1)
        
        // 字符串的base64编码
        let string = "zhangdachun"
        let base64String2 = string.bytes.toBase64()
        print("base64String2 = ", base64String2)
        
    }
    
}

// MD5：Message digest algorithm 5（信息 摘要 算法 5）
/**
 散列函数：产生128位（16字节）（备注：一字节8位）的散列值
 1) 先转化成ASCLL码16进制
 2）对16进制数据进行填充和附加，使其能够被512整除
 2.1：填充首位用1，其他位全部为0，满足 (n*512 - 64)位
 2.2：附加指的是对原始信息的长度，需要在后面补充64位，如果长度大于64位，则只取低64位
 通过填充和附加，使的数据变成512位
 3：将得到数据进行拆分，按照512位分块，每个512位分成4个128位数据块最后将4个128位的数据块依次送到不同的散列函数进行4轮运算，每一轮又按照32位的小数据块进行复杂运算，最后将得到一个128位的哈希值
 */
private extension CryptoSwiftVC {
    
    func digest() {
        
        // 计算字节数组的MD5值
        let bytes: Array<UInt8> = [0x01, 0x02, 0x03]
        let digest1 = bytes.md5().toHexString()
        print("digest1 = ", digest1)
        print("count = ", digest1.count)
        
        // 计算字符串的MD5值
        let digest2 = "zhangdachun".md5()
        print("digest2 = ", digest2)
        
    }
    
}

/**
 SHA：安全散列算法 Secure Hash Algorithm
 */
private extension CryptoSwiftVC {
    
    // 计算字节数组的SHA值
    func sha1() {
        
        let bytes: Array<UInt8> = [0x01, 0x02, 0x03]
        
//        let digest1 = bytes.sha1().toHexString()
//        let digest2 = bytes.sha224().toHexString()
//        let digest3 = bytes.sha256().toHexString()
//        let digest4 = bytes.sha384().toHexString()
//        let digest5 = bytes.sha512().toHexString()
        
        let digest1 = Digest.sha1(bytes).toHexString()
        let digest2 = Digest.sha224(bytes).toHexString()
        let digest3 = Digest.sha256(bytes).toHexString()
        let digest4 = Digest.sha384(bytes).toHexString()
        let digest5 = Digest.sha512(bytes).toHexString()
        
        print("digest1 = ", digest1)
        print("digest2 = ", digest2)
        print("digest3 = ", digest3)
        print("digest4 = ", digest4)
        print("digest5 = ", digest5)
        
    }
    
    // 计算Data的SHA值
    func sha2() {
        
        let data = Data(bytes: [0x01, 0x02, 0x03])
        let digest1 = data.sha1().toHexString()
        let digest2 = data.sha224().toHexString()
        let digest3 = data.sha256().toHexString()
        let digest4 = data.sha384().toHexString()
        let digest5 = data.sha512().toHexString()
        
        print("digest1 = ", digest1)
        print("digest2 = ", digest2)
        print("digest3 = ", digest3)
        print("digest4 = ", digest4)
        print("digest5 = ", digest5)
        
    }
    
    // 计算字符串的SHA值
    func sha3() {
        
        let digest1 = "zhangdachun".sha1()
        let digest2 = "zhangdachun".sha224()
        let digest3 = "zhangdachun".sha256()
        let digest4 = "zhangdachun".sha384()
        let digest5 = "zhangdachun".sha512()
        
        print("digest1 = ", digest1)
        print("digest2 = ", digest2)
        print("digest3 = ", digest3)
        print("digest4 = ", digest4)
        print("digest5 = ", digest5)
        
    }
    
}

// CRC校验码计算：循环冗余校验码（Cyclic Redundancy Check），是通信领域中最常用的一种查错校验码，保证数据的传输的完整性和正确性
private extension CryptoSwiftVC {
    
    // 计算字节数组的CRC值
    func crc1() {
        
        // 计算字节数组的CRC值
        let bytes: Array<UInt8> = [0x01, 0x02, 0x03]
        let crc1 = bytes.crc16()
        let crc2 = bytes.crc32()
        
        print("crc1 = ", crc1)
        print("crc2 = ", crc2)
        
    }
    
    // 计算Data的CRC值
    func crc2() {
        
        let data = Data(bytes: [0x01, 0x02, 0x03])
        let crc1 = data.crc16().toHexString()
        let crc2 = data.crc32().toHexString()
        
        print("crc1 = ", crc1)
        print("crc2 = ", crc2)
        
    }
    
    // 计算字符串的CRC值
    func crc3() {
        
        let crc1 = "zhangdachun".crc16()
        let crc2 = "zhangdachun".crc32()
        
        print("crc1 = ", crc1)
        print("crc2 = ", crc2)
        
    }
    
    
}

// MAC：散列消息身份验证码（Hashed Message Authentication Code）
private extension CryptoSwiftVC {
    
    func mac1() {
        
        let password = "zhangdachun"
        let key = "zdc"
        let hmac1 = try! HMAC(key: key.bytes, variant: .sha1).authenticate(password.bytes)
        let hmac2 = try! HMAC(key: key.bytes, variant: .sha2(.sha256)).authenticate(password.bytes)
        let hmac3 = try! HMAC(key: key.bytes, variant: .md5).authenticate(password.bytes)
        
        print("原始字符串：\(password)")
        print("key：\(key)")
        print("HMAC运算结果：\(hmac1.toHexString())")
        print("HMAC运算结果：\(hmac2.toHexString())")
        print("HMAC运算结果：\(hmac3.toHexString())")
        
    }
    
}

// 计算 Poly1305：用于检测验证的完整性和校验消息的可靠性
private extension CryptoSwiftVC {
    
    func poly() {
        
        let password = "zhangdachun"
        let key = "dc12323e238ey78u909u823e723ewewefrrfegfg"
        let mac = try! Poly1305(key: key.bytes).authenticate(password.bytes)
        
        print("password = ", password)
        print("key = ", key)
        print("Poly1305运算结果 = ", mac.toHexString())
        
    }
    
}

// PBKDF2
private extension CryptoSwiftVC {
    
    /**
     password：用来生成密钥的原始密码
     salt：加密用的盐值
     iterations：重复计算的次数。默认值：4096
     keyLength：期望得到的密钥的长度。默认值：不指定
     variant：加密使用的伪随机函数。默认值：sha256
     */
    
    func salt1() {
        
        let password = "zhangdachun"
        let salt = "Ut3Opm78U76VbwoP4Vx6UdfN234Esaz9"
        let result = try! PKCS5.PBKDF2(password: password.bytes, salt: salt.bytes).calculate()
        
        print("password = \(password)")
        print("salt = \(salt)")
        print("result = \(result.toHexString())")
        
    }
    
    func salt2() {
        
        let password = "hangge2017"
        let salt = "Ut3Opm78U76VbwoP4Vx6UdfN234Esaz9"
        let result = try! PKCS5.PBKDF2(password: password.bytes, salt: salt.bytes, iterations: 4096,
                                       variant: .md5).calculate()
        
        print("password = \(password)")
        print("salt = \(salt)")
        print("result = \(result.toHexString())")
        
    }
    
    
    
}

// AES加密：对称加密 https://blog.csdn.net/u012581020/article/details/131246733
/**
 加密原理：
 AES 加密算法是一种多分组密码体制，将明文按照大小进行分组，然后对每一个分组进行加密。在加密过程中，AES算法采用了多轮加密的方式，每一轮加密都包含了四种操作：
 SubBytes、ShiftRows、MixColumns 和 AddRoundKey
 加密解密需要密钥，使用相同的密钥作为关键参数。密钥长度 128 、192、256 bit
 */
private extension CryptoSwiftVC {
    
    @available(iOS 13.0, *)
    func aes() {
        
        // 生成密钥
//        let key = SymmetricKey(size: .bits256)
//        print("key = ", key)
        
        /**
         /// 加密
         let key = "1234567890123456"
         let en = try? AESEncyptUtil.encrypt_AES_ECB(encryptText: "123", key: key)
         if let str = en {
            print(str)
         /// 加密
            let de = try? AESEncyptUtil.decrypt_AES_ECB(decryptText: str, key: key)
             print(de)
         }
         */
        
        let key = "1234567890123456"
        let en = try? AESEncyptUtil.encrypt_AES_ECB(encryptText: "zhangdachun", key: key)
        if let str = en {
            print("str = ", str)
            let de = try? AESEncyptUtil.decrypt_AES_ECB(decryptText: str, key: key)
            if let ps = de {
                print("ps = ", ps)
            }
        }
        
        
    }
    
}

