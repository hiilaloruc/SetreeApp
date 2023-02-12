//
//  SocialFriendsTableViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.02.2023.
//

import UIKit

class SocialFriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var subInfoLabel : UILabel!
    @IBOutlet weak var userImageView : UIImageView!
    @IBOutlet weak var followButton : UIButtonX!
    
    internal var tappedUser : (() -> ())?
    internal var tappedFollow : (() -> ())?
    internal var isFollowed: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followButton.tintColor = UIColor.mainRoyalBlueColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedCell(_ sender: Any){
        print("jj: cell Clicked")
        self.tappedUser?()
    }
    
    @IBAction func clickedFollowBtn(_ sender: Any){
        print("jj: follow Clicked")
        self.tappedFollow?()
    }
}
