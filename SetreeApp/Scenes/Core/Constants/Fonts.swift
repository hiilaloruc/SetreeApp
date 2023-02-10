//
//  Fonts.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.02.2023.
//

import UIKit

extension UIFont {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
    static func sfBold(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "SFUIDisplay-Bold", size: size)
    }
    static func sfLight(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "SFUIDisplay-Light", size: size)
    }
    static func sfMedium(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "SFUIDisplay-Medium", size: size)
    }
    static func sfRegular(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "SFUIDisplay-Regular", size: size)
    }
    static func sfSemibold(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "SFUIDisplay-Semibold", size: size)
    }
    
}
