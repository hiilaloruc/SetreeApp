//
//  GoalsDetailViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 23.03.2023.
//

import UIKit

class GoalsDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    internal var goalObject: [Any] = []
    
    internal var color : UIColor? {
        didSet{
            self.view.backgroundColor = color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    
        if let title = goalObject[0] as? String {
            self.title = title
        }
        navigationController?.navigationBar.tintColor = .white
      

    }

}

extension GoalsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (goalObject[2] as AnyObject).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        if let items = goalObject[2] as? [String], indexPath.row < items.count {
            let singleGoalView = SingleGoalView(frame: cell.contentView.bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)))
            singleGoalView.contentLabel.text = items[indexPath.row]
            singleGoalView.checkImageView.tintColor = color
            singleGoalView.tappedCheckImage = {
                //request handled via api
                singleGoalView.checked.toggle()
            }
            cell.contentView.addSubview(singleGoalView)
        }

        
        return cell
    }

    
}

