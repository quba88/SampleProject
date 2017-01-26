//
//  KeychainWraper.swift
//  SampleProject
//
//  Created by Jakub Krystek on 11.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import Foundation
import Security

enum KeychainWrapperError:Error {
    case unknown
    case exist
    case save(String)
    case parse(String)
    case delete(String)
    case fetch(String)
    case emptyLogin
    case emptyPassword
}


fileprivate class RSAKeyMapper:NSObject, NSCoding{
    
    private(set)  var publicKey:(UInt, UInt) = (0,0)
    private(set)  var privateKey:(UInt, UInt) = (0,0)
    
    
    convenience init(publicKey:(UInt, UInt), privateKey:(UInt,UInt)) {
        self.init()
        
        self.publicKey = publicKey
        self.privateKey = privateKey
        
    }
    
    // MARK: - nsCoding protocol
    
    required convenience init?(coder aDecoder: NSCoder){
        self.init()
        
        let publicKeyValue0 = aDecoder.decodeObject(forKey: "storeValueOfPublicKey0") as? UInt
        let publicKeyValue1 = aDecoder.decodeObject(forKey: "storeValueOfPublicKey1") as? UInt
        
        
        if let pubK0 = publicKeyValue0, let pubK1 = publicKeyValue1{
            self.publicKey = (pubK0, pubK1)
        }
        
        
        let privateKeyValue0 = aDecoder.decodeObject(forKey: "storeValueOfPrivateKey0") as? UInt
        let privateKeyValue1 = aDecoder.decodeObject(forKey: "storeValueOfPrivateKey1") as? UInt
        
        
        if let privK0 = privateKeyValue0, let privK1 = privateKeyValue1{
            self.privateKey = (privK0, privK1)
        }
        
    }
    
     func encode(with aCoder: NSCoder){
        aCoder.encode(self.publicKey.0, forKey: "storeValueOfPublicKey0")
        aCoder.encode(self.publicKey.1, forKey: "storeValueOfPublicKey1")
        
        aCoder.encode(self.privateKey.0, forKey: "storeValueOfPrivateKey0")
        aCoder.encode(self.privateKey.1, forKey: "storeValueOfPrivateKey1")
    }
}


class KeychainWrapper{
    
    private class func createKeychainItem(login:String) -> [String:Any]{
        
        var keychainItem = [String:Any]()
        keychainItem[kSecClass as String] = kSecClassGenericPassword as String
        keychainItem[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked as String
        keychainItem[kSecAttrAccount as String] = login
        keychainItem[kSecReturnData as String] = kCFBooleanTrue  as Bool
        keychainItem[kSecReturnAttributes as String] = kCFBooleanTrue  as Bool;
        return keychainItem }
    
    
    
    class func createAccount(login:String, password:String) throws -> Bool{
        
        if login.characters.count == 0{
            
            throw KeychainWrapperError.emptyLogin
        }
        
        if password.characters.count == 0{
            
            throw KeychainWrapperError.emptyPassword
        }
        
        
        var keychainItem = KeychainWrapper.createKeychainItem(login: login)
        
        var status = SecItemCopyMatching(keychainItem as CFDictionary, nil)
        
        if status == noErr{
            throw KeychainWrapperError.exist
        }
        
        guard let passwordData = password.data(using: String.Encoding.utf8) else {
            throw KeychainWrapperError.parse("error to parse password")
        }
        
        keychainItem[kSecValueData as String] = passwordData
        status = SecItemAdd(keychainItem as CFDictionary, nil)
        
        if status != errSecSuccess{
            throw KeychainWrapperError.save("Save Error status code: \(status)")
        }
        
        return true
    }
    
    
    
    class func deleteAccount(login:String) throws -> Bool{
        
        let keychainItem = KeychainWrapper.createKeychainItem(login: login)
        
        var status = SecItemCopyMatching(keychainItem as CFDictionary, nil)
        
        if status == errSecSuccess {
            
            status = SecItemDelete(keychainItem as CFDictionary)
            
            if status != errSecSuccess{
                throw KeychainWrapperError.delete("remove account error code: \(status)")
            }
            return true
        }
        else{
            throw KeychainWrapperError.delete("account not exist: \(status)")
        }
    }
    
    
    
    class func validateUserAccess(login:String, password:String) throws -> Bool {
        
        if login.characters.count == 0{
            
            throw KeychainWrapperError.emptyLogin
        }
        
        if password.characters.count == 0{
            
            throw KeychainWrapperError.emptyPassword
        }
        
        
        let keychainItem = KeychainWrapper.createKeychainItem(login: login)
        var result:CFTypeRef?
        let status = SecItemCopyMatching(keychainItem as CFDictionary, &result)
        
        guard let keychainDic = result as? [String:Any] else{
            throw KeychainWrapperError.fetch("get user data error statusCode \(status)")
        }
        
        let passwordData = keychainDic[kSecValueData as String] as! NSData
        
        return passwordData.isEqual(to: password.data(using: String.Encoding.utf8)!)}
    
    
    
    class func storageRSAKeys(publicKey:(UInt, UInt), privateKey:(UInt, UInt), forUser login:String) throws ->Bool{
        
        var keychainItem = KeychainWrapper.createKeychainItem(login: "\(login)_rsaKeys")
        var status = SecItemCopyMatching(keychainItem as CFDictionary, nil)
        
        if status == noErr{ //accout exist storage keys
            let rsaKeyMapper = RSAKeyMapper(publicKey: publicKey, privateKey: privateKey)
            let data = NSKeyedArchiver.archivedData(withRootObject: rsaKeyMapper)
            keychainItem[kSecValueData as String] = data
            status = SecItemAdd(keychainItem as CFDictionary, nil)
            
            if status != errSecSuccess{
                throw KeychainWrapperError.save("Save Error status code: \(status)")
            }
            
            return true
        }
        else{
            throw KeychainWrapperError.exist
        }
        
    }
    
    
    class func getRSAPublicKey(forUser login:String) throws -> (UInt, UInt){
    
        let keychainItem = KeychainWrapper.createKeychainItem(login: "\(login)_rsaKeys")
        var result:CFTypeRef?
        let status = SecItemCopyMatching(keychainItem as CFDictionary, &result)
        
        guard let keychainDic = result as? [String:Any] else{
            throw KeychainWrapperError.fetch("get user data error statusCode \(status)")
        }
        
        let rsaKeyMapperData = keychainDic[kSecValueData as String] as! Data

        let optionalKeyMapper = NSKeyedUnarchiver.unarchiveObject(with: rsaKeyMapperData) as? RSAKeyMapper
        
        
        guard let keyMapper = optionalKeyMapper else {return (0,0)}
    
    return keyMapper.publicKey}
    
    
   internal class func getRSAPrivateKey(forUser login:String) throws -> (UInt, UInt){
        
        let keychainItem = KeychainWrapper.createKeychainItem(login: "\(login)_rsaKeys")
        var result:CFTypeRef?
        let status = SecItemCopyMatching(keychainItem as CFDictionary, &result)
        
        guard let keychainDic = result as? [String:Any] else{
            throw KeychainWrapperError.fetch("get user data error statusCode \(status)")
        }
        
        let rsaKeyMapperData = keychainDic[kSecValueData as String] as! Data
        
        let optionalKeyMapper = NSKeyedUnarchiver.unarchiveObject(with: rsaKeyMapperData) as? RSAKeyMapper
        
        
        guard let keyMapper = optionalKeyMapper else {return (0,0)}
        
        return keyMapper.privateKey}
    
}
