//
//  ProfilHeaderTableViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 11.02.2023.
//

import UIKit

class ProfilHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var listCountLabel : UILabel!
    @IBOutlet weak var followerCountLabel : UILabel!
    @IBOutlet weak var followButton : UIButton!
    internal var isFollowing: Bool = false


    override func awakeFromNib() {
        super.awakeFromNib()
        initalUI()
        
    }
    func initalUI(){
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.mainRoyalBlueColor.cgColor
            followButton.layer.cornerRadius = 20
            followButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
