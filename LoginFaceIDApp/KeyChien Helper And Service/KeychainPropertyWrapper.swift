//
//  KeychainPropertyWrapper.swift
//  LoginFaceIDApp
//
//  Created by Hakob Ghlijyan on 22.02.2024.
//

import SwiftUI

//MARK: - Custom Wraper for Keychain
// for easy to use

@propertyWrapper struct Keychain: DynamicProperty {
    
    @State var data: Data?

    init(key: String, account: String) {
        self.key = key
        self.account = account
        
        // Setting Intial State Keychain Data
        // init state data - read
        // Установка данных связки ключей начального состояния
        // Данные состояния инициализации - чтение
        _data = State(wrappedValue: KeychainHelper.instance.read(key: key, account: account) )
    }
    
    var key: String
    var account: String
    
    //1
    /*
     var wrappedValue: Data? {
         get { data }
         nonmutating set {
             // guard
             guard let newData = newValue else {
                 // if we set data to nil...
                 // Simple delete the the Keychain data
                 // если мы установим значение data равным нулю...
                 // Просто удалите данные из связки ключей
                 data = nil
                 KeychainHelper.instance.delete(key: key, account: account)
                 return
             }
             //Updating or Setting KeyChain Data
             KeychainHelper.instance.save(data: newData, key: key, account: account)
         }
     }
     */
    //2
    var wrappedValue: Data? {
        get { KeychainHelper.instance.read(key: key, account: account) }
        nonmutating set {
            // guard
            guard let newData = newValue else {
                // if we set data to nil...
                // Simple delete the the Keychain data
                // если мы установим значение data равным нулю...
                // Просто удалите данные из связки ключей
                data = nil
                KeychainHelper.instance.delete(key: key, account: account)
                return
            }
            //Updating or Setting KeyChain Data
            KeychainHelper.instance.save(data: newData, key: key, account: account)
         
            // Updating Data
            data = newValue
        }
    }
    
    var projectedValue: Binding<Data?> {
        Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }

    }
}
