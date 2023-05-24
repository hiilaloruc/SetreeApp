//
//  CollectionsCollectionViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 3.02.2023.
//

import UIKit

class CollectionsCardViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    //internal var collection : Collection!
    
    internal var tappedCell : (() -> ())?
    
    internal var bgColor : UIColor? {
        didSet{
            backView.backgroundColor = bgColor
            countView.backgroundColor = bgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func clickedCell(_ sender: Any) {
        print("jj: cell clicked")
        self.tappedCell?()
    }
}

