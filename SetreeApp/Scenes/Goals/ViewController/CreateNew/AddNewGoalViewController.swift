//
//  AddNewGoalViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 16.05.2023.
//

import UIKit
import NotificationBannerSwift

class AddNewGoalViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    internal var newGoalArr: [String] = []
    
    internal var color : UIColor? {
        didSet{
            self.view.backgroundColor = color
        }
    }
    
    private weak var goalService : GoalService?{
        return GoalService()
    }
    
    internal var goalId: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
        
        let createButton = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createButtonTapped))
        navigationItem.rightBarButtonItem = createButton
        
        
    }
    @objc func createButtonTapped() {
        print("Create button tapped request is sending to api...")
        
        if let cell = tableView.cellForRow(at: IndexPath(row: tableView.numberOfRows(inSection: 0)-2, section: 0)) as? UITableViewCell,
           let singleGoalView = cell.contentView.subviews.first as? SingleGoalView {
            if singleGoalView.textView.text != "" {
                self.newGoalArr.append(singleGoalView.textView.text)
                createRequest(goalArr: self.newGoalArr)
            }else{
                if (self.newGoalArr.count == 0){
                    let banner = GrowingNotificationBanner(title: "Missing goal", subtitle: "Goal field cannot be empty.", style: .danger)
                    banner.show()
                    return
                }
                createRequest(goalArr: self.newGoalArr)
            }
        }
    }
    
    func createRequest(goalArr: [String]) {
        let itemArray = goalArr.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        print("The goals being sent to DB:", itemArray)
    
        //API req:
        goalService?.createMultipleGoalItems(goalItemsArray: itemArray, goalId: self.goalId){ result in
            switch result {
            case .success(let message):
                print("message: ", message)
                // Perform here the actions to be taken when the user is successfully registered
                Banner.showSuccessBanner(message:message)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGoalObject"), object: nil)
                self.dismiss(animated: true)

            case .failure(let error):
                print("Sorry, goals couldn't added: ERROR: \(error.localizedDescription)")
                // Perform here the actions to be taken when the user is not registered
                Banner.showErrorBanner(with: error)
            }
        }
        
    }

}

extension AddNewGoalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (newGoalArr.count )  + 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        if indexPath.row < newGoalArr.count {
            let singleGoalView = SingleGoalView(frame: cell.contentView.bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)))
            singleGoalView.textView.isHidden = false
            singleGoalView.contentLabel.isHidden = true
            singleGoalView.textView.text = newGoalArr[indexPath.row]
            singleGoalView.checkImageView.tintColor = color
            
            cell.contentView.addSubview(singleGoalView)
            
            
        }else if (indexPath.row == newGoalArr.count) {
            let singleGoalView = SingleGoalView(frame: cell.contentView.bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)))
            singleGoalView.contentLabel.isHidden = true
            singleGoalView.textView.isHidden = false
            singleGoalView.textView.text = ""
            singleGoalView.checkImageView.tintColor = color
            singleGoalView.textView.becomeFirstResponder()
            
            cell.contentView.addSubview(singleGoalView)
        }else {
            // add new button cell
            let addButton = UIButton(type: .system)
            addButton.frame = cell.contentView.bounds
            addButton.setTitle("+ Add another goal", for: .normal)
            addButton.titleLabel?.textAlignment = .center
            addButton.setTitleColor(.systemBlue, for: .normal)
            addButton.addTarget(self, action: #selector(addNewGoalButtonTapped), for: .touchUpInside)
            cell.contentView.addSubview(addButton)
        }
        
        return cell
    }
    
    @objc func addNewGoalButtonTapped() {
        if let cell = tableView.cellForRow(at: IndexPath(row: tableView.numberOfRows(inSection: 0)-2, section: 0)) as? UITableViewCell,
           let singleGoalView = cell.contentView.subviews.first as? SingleGoalView {
            if singleGoalView.textView.text == "" {
                let banner = GrowingNotificationBanner(title: "Missing goal", subtitle: "Goal field cannot be empty.", style: .danger)
                banner.show()
                return
            }
        }

        // Add New button tapped, handle the action
        print("addNewGoalButtonTapped...")
        
        newGoalArr = []
        for i in 0..<(tableView.numberOfRows(inSection: 0) - 1){
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? UITableViewCell,
               let singleGoalView = cell.contentView.subviews.first as? SingleGoalView {
                     newGoalArr.append(singleGoalView.textView.text ?? "")
            }
        }
        
        print("newGoalArr: ", newGoalArr)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            if (indexPath.row < (self.newGoalArr.count ?? 0) ){
                print("silme işlemini gerçekleştir2 , silinecek: \(self.newGoalArr[indexPath.row])")
                self.newGoalArr.remove(at: indexPath.row)
                print("newGoalArr: ", self.newGoalArr)
                tableView.reloadData()
            }else{
                print("out of range indexpath.row: \(indexPath.row) , arrCount: ", self.newGoalArr.count ?? 0)
            }
        }
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // silme işlemini gerçekleştir
            
        }
    }


    
}


