//
//  KeychainHelper.swift
//  LoginFaceIDApp
//
//  Created by Hakob Ghlijyan on 22.02.2024.
//

import SwiftUI


//MARK: - Keychain Helper class

final class KeychainHelper {
    
    //To Acess Class Data - SINGLTONE
    static let instance = KeychainHelper()
    
    //MARK: - Save - data - my password
    func save(data: Data, key: String, account: String) {
        // Creating Query
        let query = [
            kSecValueData: data,
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        // Adding Data to KeyChain
        let status = SecItemAdd(query, nil)
        
        // Checking for Status
        switch status {
            // For Success ->
        case errSecSuccess:
            print("Success SAVED!!!")
            // For DuplicateItem -> Updating Data
        case errSecDuplicateItem:
            let updateQuery = [
                kSecValueData: data,
                kSecAttrAccount: account,
                kSecAttrService: key,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            // Update filed
            let updateAttr = [kSecValueData: data] as CFDictionary
            SecItemUpdate(updateQuery, updateAttr)
            // For Error ->
        default:
            print("Error \(status)")
        }
    }
    
    //MARK: - Get - Reading Keychain data
    func read(key: String, account: String)  -> Data? {
        // Creating Query
        let readingQuery = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        // To copy the data
        var resultData: AnyObject?
        
        let status = SecItemCopyMatching(readingQuery, &resultData)
        
        switch status {
        case errSecSuccess:
            print("Success Data Read!!!")
        default:
            print("Error \(status)")
        }
        
        return resultData as? Data
    }
    
    //MARK: - Delete in Keychain data
    func delete(key: String, account: String) {
        // Creating Query
        let deletedQuery = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        //Delete for data
        SecItemDelete(deletedQuery)
    }
}
