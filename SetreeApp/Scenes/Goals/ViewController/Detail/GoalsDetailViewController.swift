//
//  GoalsDetailViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 23.03.2023.
//
import UIKit
import NotificationBannerSwift

class GoalsDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    internal var goalObject: Goal!
    
    internal var color : UIColor? {
        didSet{
            self.view.backgroundColor = color
        }
    }
    private weak var goalService: GoalService?{
        return GoalService()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    
        self.title = goalObject.title
        navigationController?.navigationBar.tintColor = .white
        
       // updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NSNotification.Name(rawValue: "updateGoalObject") , object: nil)

    }

    
    @objc func updateData(){
        print("updateData() called..")
        goalService?.getGoalDetail(goalId: self.goalObject.goalId){ result in
            switch result {
            case .success(let goal ):
                self.goalObject = goal
                self.tableView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGoalsAll"), object: nil)
                
            case .failure(let error):
                let banner = GrowingNotificationBanner(title: "Something went wrong while retrieving the data.", subtitle: "Error: \(error.localizedDescription) ", style: .danger)
                banner.show()

            }
        }
       
       
    }

}

extension GoalsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (goalObject.goalItems?.count ?? 0)  + 1
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
        }else {
            // add new button cell
            let addButton = UIButton(type: .system)
            addButton.frame = cell.contentView.bounds
            addButton.setTitle("+ Add New", for: .normal)
            addButton.titleLabel?.textAlignment = .center
            addButton.setTitleColor(.systemBlue, for: .normal)
            addButton.addTarget(self, action: #selector(addNewGoalButtonTapped), for: .touchUpInside)
            cell.contentView.addSubview(addButton)
        }
        
        return cell
    }
    
    @objc func addNewGoalButtonTapped() {
        // Add New button tapped, handle the action
        print("addNewGoalButtonTapped...")
        
        if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AddNewGoalViewController") as? AddNewGoalViewController{
            vc.goalId = self.goalObject.goalId
            vc.title = "Create New Goal"
            vc.color = color
            self.present(UINavigationController(rootViewController:vc), animated: true)
        }
        
        
        
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

