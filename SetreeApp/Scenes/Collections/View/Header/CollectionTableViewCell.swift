//
//  TitleHeaderTableViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 8.02.2023.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
    }
    
}
