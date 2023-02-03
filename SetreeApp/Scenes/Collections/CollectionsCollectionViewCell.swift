//
//  CollectionsCollectionViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 3.02.2023.
//

import UIKit

class CollectionsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    internal var bgColor : UIColor? {
        didSet{
            backView.backgroundColor = bgColor
            countView.backgroundColor = bgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //collectionCardView.titleLabel.text = "Hilal"
        
    }
}

