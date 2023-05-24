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
            self.stackView.backgroundColor = UIColor.white
            containerView.backgroundColor = self.color?.withAlphaComponent(0.2)
            for subview in bottomView.subviews {
                subview.backgroundColor = self.color
            }
        }
    }
    internal var tappedCheck : ((_ itemId: Int?)->(Bool))?
    internal var tappedGoalDetail : (()->())?

    internal var goalsArray: [GoalItem]? {
        didSet {
            // Remove all existing arranged subviews from the stack view
            stackView.arrangedSubviews.forEach {
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            // Add a new SingleGoalView for each goal in the array
            for goal in goalsArray! {
                let goalItem = SingleGoalView()
                goalItem.contentLabel.text = goal.content
                goalItem.checked = goal.isDone
                goalItem.checkImageView.tintColor = self.color
                goalItem.containerView.backgroundColor = self.color?.withAlphaComponent(0.2)
                goalItem.translatesAutoresizingMaskIntoConstraints = false
                goalItem.tappedCheckImage =  {
                    if ( (self.tappedCheck?(goal.goalItemId) != nil) &&  self.tappedCheck!(goal.goalItemId) ) {
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
