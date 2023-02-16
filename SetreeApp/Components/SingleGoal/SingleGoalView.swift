//
//  SingleGoalView.swift
//  SetreeApp
//
//  Created by HilalOruc on 16.02.2023.
//

import UIKit

class SingleGoalView: BaseView {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    internal var checked: Bool! = false

    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.numberOfLines = 0
    }
}
