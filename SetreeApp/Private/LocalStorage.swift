//
//  LocalStorage.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.05.2023.
//

import Foundation

struct LocalStorage {
    
    static func getItem<T>(key : String) -> T? {
        let userDefault = UserDefaults.standard
        if let data = userDefault.object(forKey: key) as? NSData {
            let decodedObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
            return decodedObject as? T
        }
        return nil
    }
    
    static func setItem<T>(_ key : String , value : T) {
        let userDefault = UserDefaults.standard
        let data: Data? = NSKeyedArchiver.archivedData(withRootObject: value) as Data?
        userDefault.set(data, forKey: key)
        userDefault.synchronize()
    }
    
    static func setEncodableItem<T : Encodable>(_ key : String , value : T) {
        let jsonEncoder = JSONEncoder()
        let data = try! jsonEncoder.encode(value)
        setItem(key, value: data)
    }
    
    static func getDecodableItem<T : Decodable>(_ key : String) -> T? {
        let decoder = JSONDecoder()
        
        if let item : Data? = getItem(key: key){
            
            return try! decoder.decode(T.self, from: item!) as T?
        }
        return nil
    }
}
