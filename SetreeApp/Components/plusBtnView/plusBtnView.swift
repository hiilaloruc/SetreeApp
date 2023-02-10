//
//  plusBtnView.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.02.2023.
//

import UIKit

class plusBtnView: BaseView {

    internal var tappedPlusBtn : (() -> ())?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    @IBAction func clickedPlusBtn(_ sender: Any) {
        self.tappedPlusBtn?()
    }

}
