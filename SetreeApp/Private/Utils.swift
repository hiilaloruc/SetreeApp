//
//  Utils.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.05.2023.
//

import Foundation

public class Utils {
    
    public static func isLoggedIn() -> Bool{
        
        if let _ : String? = LocalStorage.getItem(key: "baseTOKEN") {
            return true
        }
        return false
    }
}
