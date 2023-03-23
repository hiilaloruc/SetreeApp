//
//  GoalCardTableViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 16.02.2023.
//

import UIKit

class GoalCardTableViewCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomView: UIView!

    internal var color : UIColor? {
        didSet{
            for subview in bottomView.subviews {
                subview.backgroundColor = self.color
            }
        }
    }
    internal var tappedCheck : ((_ itemId: String?)->(Bool))?
    internal var tappedGoalDetail : (()->())?

    internal var goalsArray: [String]? {
        didSet {
            // Remove all existing arranged subviews from the stack view
            stackView.arrangedSubviews.forEach {
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            // Add a new SingleGoalView for each goal in the array
            for goal in goalsArray! {
                let goalItem = SingleGoalView()
                goalItem.contentLabel.text = goal
                goalItem.checkImageView.tintColor = self.color
                goalItem.translatesAutoresizingMaskIntoConstraints = false
                goalItem.tappedCheckImage =  {
                    if ( (self.tappedCheck?("1_CustomId") != nil) &&  self.tappedCheck!("1_CustomId") ) {
                        goalItem.checked.toggle()
                    }
                   
                }
                stackView.addArrangedSubview(goalItem)
            }
            stackView.layoutIfNeeded()
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 30
        containerView.layer.masksToBounds = true
    
        self.bottomView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goalDetailClicked))
        self.bottomView.addGestureRecognizer(tapGestureRecognizer)

    }
    @objc func goalDetailClicked(){
        print("Goal detail clicked -> \(titleLabel.text)")
        self.tappedGoalDetail?()
        
    }


}
