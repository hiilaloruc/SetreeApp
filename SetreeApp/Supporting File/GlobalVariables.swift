//
//  GlobalVariables.swift
//  SetreeApp
//
//  Created by HilalOruc on 5.02.2023.
//

import Foundation
import NotificationBannerSwift

let collectionCardColorsArr = ["softOrange", "softLilac","verySoftRed","softGreen", "softPink", "softDarkblue" ]

class Banner{
    static func showErrorBanner(with error: Error) {
        print("An error occurred: \(error)")
        let banner = GrowingNotificationBanner(title: "Error", subtitle: "\(error.localizedDescription).", style: .danger)
        banner.show()
    }

    static func showSuccessBanner(message: String) {
        let banner = GrowingNotificationBanner(title: "Success", subtitle: message, style: .success)
        banner.show()
    }
    
    static func  showInfoBanner(message: String) {
        let banner = GrowingNotificationBanner(title: "Info", subtitle:message , style: .info)
        banner.show()
    }
}
