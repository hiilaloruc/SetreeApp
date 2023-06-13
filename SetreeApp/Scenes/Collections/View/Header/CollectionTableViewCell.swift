//
//  CollectionTableViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 8.02.2023.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    //@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
   
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        
        // Hücre seçili olduğunda arkaplan rengini değiştirme
          selectionStyle = .none
        
    }
    @IBOutlet weak var userImageView : UIImageView!
    
    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Hücre seçili olduğunda arkaplan rengini ayarla
        if selected {
            backgroundColor = UIColor.clear
        }
    }*/

}
