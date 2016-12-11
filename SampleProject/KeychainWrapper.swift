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

}

class KeychainWrapper{

    class func createAccount(login:String, password:String) throws{

        var keychainItem = [String:Any]()
        keychainItem[kSecClass as String] = kSecClassGenericPassword as String
        keychainItem[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked as String
        keychainItem[kSecAttrAccount as String] = login
        keychainItem[kSecReturnData as String] = kCFBooleanTrue  as Bool
        keychainItem[kSecReturnAttributes as String] = kCFBooleanTrue  as Bool;
        
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
    }
    
    
    
    class func deleteAccount(login:String) throws{
    
        var keychainItem = [String:Any]()
        keychainItem[kSecClass as String] = kSecClassGenericPassword as String
        keychainItem[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked as String
        keychainItem[kSecAttrAccount as String] = login
        keychainItem[kSecReturnData as String] = kCFBooleanTrue  as Bool
        keychainItem[kSecReturnAttributes as String] = kCFBooleanTrue  as Bool;
        
        var status = SecItemCopyMatching(keychainItem as CFDictionary, nil)
        
        if status == errSecSuccess {
            
            status = SecItemDelete(keychainItem as CFDictionary)
            
            if status != errSecSuccess{
                throw KeychainWrapperError.delete("remove account error code: \(status)")
            }
        }
    }
    
}
