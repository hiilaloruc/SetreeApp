//
//  GoalsDetailViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 23.03.2023.
//
import UIKit

class GoalsDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    internal var goalObject: Goal!
    
    internal var color : UIColor? {
        didSet{
            self.view.backgroundColor = color
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    
        self.title = goalObject.title
        navigationController?.navigationBar.tintColor = .white
      

    }

}

extension GoalsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalObject.goalItems?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        if (indexPath.row < goalObject.goalItems!.count) {
            let singleGoalView = SingleGoalView(frame: cell.contentView.bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)))
            singleGoalView.contentLabel.text = goalObject.goalItems![indexPath.row].content
            singleGoalView.checked = goalObject.goalItems![indexPath.row].isDone
            singleGoalView.checkImageView.tintColor = color
            singleGoalView.tappedCheckImage = {
                //request handled via api
                singleGoalView.checked.toggle()
            }
            cell.contentView.addSubview(singleGoalView)
        }

        
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Sil") { (action, indexPath) in
            // silme işlemini gerçekleştir
            print("silme işlemini gerçekleştir")
        }
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // silme işlemini gerçekleştir
            print("silme işlemini gerçekleştir2")
        }
    }


    
}

