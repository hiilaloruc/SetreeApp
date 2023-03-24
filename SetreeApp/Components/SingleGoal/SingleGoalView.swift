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
    @IBOutlet weak var containerView: UIView!
    
    internal var tappedCheckImage : (() -> ())?
    internal var checked: Bool = false {
        didSet{
            if (checked) {
               guard let text = contentLabel.text else { return }
               let attributedString = NSAttributedString(string: text, attributes: [
                   .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                   .strikethroughColor: UIColor.black.withAlphaComponent(0.5)
               ])
               contentLabel.attributedText = attributedString
           } else {
               guard let text = contentLabel.text else { return }
               let attributedString = NSAttributedString(string: text)
               contentLabel.attributedText = attributedString
               contentLabel.textColor = UIColor.black
           }
           checkImageView.image = checkImage
        }
    }
    private var checkImage: UIImage? {
        return UIImage(systemName: checked ? "checkmark.circle.fill" : "checkmark.circle")
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
