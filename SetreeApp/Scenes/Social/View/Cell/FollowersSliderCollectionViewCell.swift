//
//  followersSliderCollectionViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 11.02.2023.
//

import UIKit

class FollowersSliderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userImageView :UIImageView!
    
    internal var tappedCell : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.isUserInteractionEnabled = true
        self.userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedCell)))
        
    }

    @objc func clickedCell(){
        print("jj: asdadadadadd1")
        self.tappedCell?()
    }
}
