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
    
    internal var tappedCheckImage : (() -> ())?
    internal var checked: Bool! = false {
        didSet{
            if checked{
                checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            }else{
                checkImageView.image = UIImage(systemName: "checkmark.circle")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.numberOfLines = 0
        
    }
    
    @IBAction func clickedCheck(_ sender: Any){
        print("Goal item clicked!")
        self.tappedCheckImage?()
    }

}
