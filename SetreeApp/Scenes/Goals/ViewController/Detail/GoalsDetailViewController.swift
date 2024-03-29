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
    internal var tappedCheck : ((_ itemId: Int?)->(Bool))?

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    
        self.title = goalObject.title
        navigationController?.navigationBar.tintColor = .white
        
        //Delete button creation
       let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonTapped))
       navigationItem.rightBarButtonItem = trashButton
        
       // updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NSNotification.Name(rawValue: "updateGoalObject") , object: nil)

    }

    
    @objc func updateData(){
        print("updateData() called..")
        DispatchQueue.main.async {
            LoadingScreen.show()
        }
        goalService?.getGoalDetail(goalId: self.goalObject.goalId){ result in
            DispatchQueue.main.async {
                LoadingScreen.hide()
            }
            switch result {
            case .success(let goal ):
                self.goalObject = goal
                self.tableView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGoalsAll"), object: nil)
                
            case .failure(let error):
                Banner.showErrorBanner(with: error)

            }
        }
       
       
    }
    
    @objc func trashButtonTapped() {
        print("Çöp kutusuna tıklandı")
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Delete Goal", message: "Are you sure you want to delete group?", preferredStyle: .alert)

        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Yes", style: .destructive) { _ in

            // this code runs when the user hits the "save" button
            DispatchQueue.main.async {
                LoadingScreen.show()
            }
            self.goalService?.deleteGoal(goalId: self.goalObject.goalId){ result in
                DispatchQueue.main.async {
                    LoadingScreen.hide()
                }
                switch result {
                case .success(let message):
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGoalsAll"), object: nil)
                case .failure(let error):
                    Banner.showErrorBanner(with: error)
                }
            }
            print("Deleted GOAL GROUP")
            self.navigationController?.popViewController(animated: true)
          

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
        
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
            singleGoalView.checkImageView.tintColor = color
           
            let goalItem = goalObject.goalItems![indexPath.row]
            singleGoalView.contentLabel.text = goalItem.content
            singleGoalView.checked = goalItem.isDone
            singleGoalView.checkImageView.tintColor = color
                   
            singleGoalView.tappedCheckImage = {
                if ( (self.tappedCheck?(goalItem.goalItemId) != nil) &&  self.tappedCheck!(goalItem.goalItemId) ) {
                    singleGoalView.checked.toggle()
                }
            }
            
            cell.contentView.addSubview(singleGoalView)
        }else {
            // add new button cell
            let addButton = UIButton(type: .system)
            addButton.frame = cell.contentView.bounds
            addButton.setTitle("+ Add New", for: .normal)
            addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // Adjust the font size as desired
            addButton.titleLabel?.textAlignment = .center
            addButton.setTitleColor(color, for: .normal)
            addButton.addTarget(self, action: #selector(addNewGoalButtonTapped), for: .touchUpInside)
            addButton.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(addButton)
            // Center the button using Auto Layout constraints
            NSLayoutConstraint.activate([
                addButton.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                addButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
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
    
    func refreshGoalObject(){
        DispatchQueue.main.async {
            LoadingScreen.show()
        }
        self.goalService?.getGoalDetail(goalId: self.goalObject.goalId){ result in
            DispatchQueue.main.async {
                LoadingScreen.hide()
            }
            switch result {
            case .success(let goal ):
                self.goalObject = goal
                self.tableView.reloadData()
            case .failure(let error):
                Banner.showErrorBanner(with: error)

            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Sil") { (action, indexPath) in
            // silme işlemini gerçekleştir
            DispatchQueue.main.async {
                LoadingScreen.show()
            }
            print("silme işlemini gerçekleştir satır \(indexPath.row) , item: \(self.goalObject.goalItems![indexPath.row].content)")
            self.goalService?.deleteGoalItem(goalItemId: self.goalObject.goalItems![indexPath.row].goalItemId){ result in
                DispatchQueue.main.async {
                    LoadingScreen.hide()
                }
                switch result {
                case .success(let message ):
                    self.refreshGoalObject()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGoalsAll"), object: nil)
                case .failure(let error):
                    Banner.showErrorBanner(with: error)
                }
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
            print("silme işlemini gerçekleştir2")
        }
    }


    
}

