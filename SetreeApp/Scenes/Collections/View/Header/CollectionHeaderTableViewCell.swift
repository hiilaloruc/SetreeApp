//
//  CollectionHeaderTableViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 26.05.2023.
//

import UIKit

class CollectionHeaderTableViewCell: UITableViewCell {
    //@IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var isPublicButton: UIButton!
    
    //internal var addTitleClicked: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addTitleClicked(_ sender: Any) {
        print("addTitleClicked")
    }
    @IBAction func addTextClicked(_ sender: Any) {
        print("addTextClicked")
    }
    @IBAction func addImageClicked(_ sender: Any) {
        print("addImageClicked")
    }
    
}
