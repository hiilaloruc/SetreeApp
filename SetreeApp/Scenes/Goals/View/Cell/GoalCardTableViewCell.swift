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

    internal var goalsArray: [String]? {
        didSet {
            // Remove all existing arranged subviews from the stack view
            stackView.arrangedSubviews.forEach {
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            // Add a new SingleGoalView for each goal in the array
            for goal in goalsArray! {
                let customView = SingleGoalView()
                customView.contentLabel.text = goal
                customView.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(customView)
            }
            stackView.layoutIfNeeded()
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 30
        containerView.layer.masksToBounds = true

    }


}
