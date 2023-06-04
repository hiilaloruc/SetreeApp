//
//  LoadingScreen.swift
//  SetreeApp
//
//  Created by HilalOruc on 4.06.2023.
//

import Foundation
import UIKit

class LoadingScreen {
    
    static var currentOverlay : UIView?
    static var opacity: CGFloat = 0.2
    static let overlay = UIActivityIndicatorView()

    static func show() {
        guard let currentMainWindow = UIApplication.shared.keyWindow else {
            print("No main window.")
            return
        }
        show(currentMainWindow)
    }
    
    static func show(_ overlayTarget : UIView) {
        hide()
        DispatchQueue.main.async {
                    overlay.backgroundColor = UIColor.blacks.withAlphaComponent(opacity)
                    overlay.translatesAutoresizingMaskIntoConstraints = false
                    overlay.startAnimating()
                    overlay.style = .whiteLarge

                    overlayTarget.addSubview(overlay)
                    overlayTarget.bringSubviewToFront(overlay)
                    //overlay.loadingImage.rotate()
                    
                    overlay.leftAnchor.constraint(equalTo: overlayTarget.leftAnchor, constant: 0.0).isActive = true
                    overlay.widthAnchor.constraint(equalTo: overlayTarget.widthAnchor).isActive = true
                    overlay.heightAnchor.constraint(equalTo: overlayTarget.heightAnchor).isActive = true
                    
                    UIView.beginAnimations(nil, context: nil)
                    UIView.commitAnimations()

                    currentOverlay = overlay
        }

    }
    
    static func hide() {
        if currentOverlay != nil {
            currentOverlay?.removeFromSuperview()
            currentOverlay =  nil
        }
    }
}

