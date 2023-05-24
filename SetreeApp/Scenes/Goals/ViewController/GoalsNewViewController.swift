//
//  GoalsNewViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 16.02.2023.
//

import UIKit
import NotificationBannerSwift

class GoalsNewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusButton: UIView!

    
    internal var goalsWithDetails: [Goal]? = []{
        didSet{
           // collectionsView.reloadData()
            print("goalsWithDetails updated :) new count:", goalsWithDetails?.count)
            self.tableView.reloadData()
        }
    }
    
    internal var goalsArray : [Goal]?{
        didSet{
            
        }
    }
    
    private weak var goalService: GoalService?{
        return GoalService()
    }
    
    /*var GoalObjects = [["Daily","3", [ "Call mom and remind", "Give breakfast to Max", "Give breakfast to Max"]],
    
                       ["Weekly","6", ["Visit your granmda","Go to a cinema with a friend","Explore a new technology","Call a random friend","Get a certificate from any field","Enroll a course - that you know nothing"]],
                       ["Monthly","5",  ["Join a workshop as a part of a team", "Go stay in Poland for at least  2 weeks", "Call mom and remind her medicines", "Give breakfast to Max","Go somewhere that you never did"]],
                       
                       ["Tomorrow","2", [ "Call mom and remind", "Give breakfast to Max"]]
    ]*/
    /*
    var todoArray = [
        [ "Call mom and remind", "Give breakfast to Max", "Give breakfast to Max"],
        ["Visit your granmda","Go to a cinema with a friend","Explore a new technology","Call a random friend","Get a certificate from any field","Enroll a course - that you know nothing"],
        ["Join a workshop as a part of a team", "Go stay in Poland for at least  2 weeks", "Call mom and remind her medicines", "Give breakfast to Max","Go somewhere that you never did"],
        [ "Call mom and remind", "Give breakfast to Max"]
    ]
    
    var GoalsInfoArray = [
        ["Daily","2"],
        ["Weekly","6"],
        ["Monthly","5"],
        ["Tomorrow","2"]
        ]
    
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "GoalCardTableViewCell", bundle: nil), forCellReuseIdentifier: "GoalCardTableViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(initialUI), name: NSNotification.Name(rawValue: "updateGoalsAll") , object: nil)
        

        
        initialUI()
        
        self.plusButton.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped))
        self.plusButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func plusButtonTapped(_ sender: UITapGestureRecognizer) {
        print("Plus button clicked on Goals..")
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "New Goal Group", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Weekly"
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Create", style: .default) { _ in

            // this code runs when the user hits the "save" button
            let inputTitle = alertController.textFields![0].text
            print("inputTitle: ",inputTitle)
            
            if (inputTitle != nil && inputTitle != ""){
                self.goalService?.createGoal(title: String(inputTitle!)){ result in
                    switch result {
                    case .success(let message ):
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGoalsAll"), object: nil)
                        Banner.showSuccessBanner(message:message)
                        
                        
                    case .failure(let error):
                        Banner.showErrorBanner(with: error)

                    }
                }
            }

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func getGoalDetails(){
        goalsWithDetails = []
        if self.goalsArray != nil && self.goalsArray?.count ?? 0 > 0 {
                for item in self.goalsArray! {
                    goalService?.getGoalDetail(goalId: item.goalId){ result in
                        switch result {
                        case .success(let goal ):
                            self.goalsWithDetails?.append(goal)
                             
                        case .failure(let error):
                            Banner.showErrorBanner(with: error)

                        }
                    }
                }
        }
    }
    
    @objc func initialUI(){
        if let user = baseUSER{
            goalService?.getGoals(){ result in
                switch result {
                case .success(let goals):
                    self.goalsArray = goals
                    self.getGoalDetails()
                     
                case .failure(let error):
                    Banner.showErrorBanner(with: error)

                }
            }
        }
    }
    

}

extension GoalsNewViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = goalsWithDetails?.count ?? 0
        return rowCount
        //return min(rowCount, 6) //limit with 6 rows step1/3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= 0 && indexPath.row < goalsWithDetails!.count {
            //let count = min((goalsWithDetails![indexPath.row].goalItems?.count ?? 0), 6) //limit with 6 rows  step2/3
            let count = (goalsWithDetails![indexPath.row].goalItems?.count ?? 0)
            return CGFloat((64 + 8 + ( count * 40)))
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "GoalCardTableViewCell", for: indexPath) as! GoalCardTableViewCell
        cell.selectionStyle = .none
        if let goal = goalsWithDetails?[indexPath.row] {
            cell.color = UIColor(named: collectionCardColorsArr[indexPath.row % collectionCardColorsArr.count])!
            cell.titleLabel.text = goal.title
            cell.countLabel.text = String(goal.goalItems?.count ?? 0)
            //cell.goalsArray = Array(goal.goalItems?.prefix(6) ?? []) //limit with 6 rows  step3/3
            cell.goalsArray = goal.goalItems
            cell.tappedCheck = { itemId in
                if let itemId = itemId {
                    self.handleTappedCheck(goal: goal, itemId: itemId, indexPath: indexPath)
                                return true
                            } else {
                                print("The item id is not applicable. itemId: \(itemId)")
                                return false
                            }
            }
        
        cell.tappedGoalDetail = {
            if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "GoalsDetailViewController") as? GoalsDetailViewController{
                vc.goalObject = self.goalsWithDetails![indexPath.row]
                vc.color = cell.color
                vc.tappedCheck = { itemId in
                    if let itemId = itemId {
                        self.handleTappedCheck(goal: goal, itemId: itemId, indexPath: indexPath)
                                               return true
                                           } else {
                                               print("The item id is not applicable. itemId: \(itemId)")
                                               return false
                    }
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
           
            } }
    
        }
        // Add the custom separator view to the bottom of the cell
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.white
        separatorView.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
        cell.contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        
        return cell
    }
    
    func handleTappedCheck(goal: Goal, itemId: Int, indexPath: IndexPath) {
        print("isDone clicked on itemId: \(itemId)")
        
        guard let goalItemIndex = goal.goalItems?.firstIndex(where: { $0.goalItemId == itemId }),
              let goalItemContent = goal.goalItems?[goalItemIndex].content else {
            print("Goal item not found with itemId: \(itemId)")
            return
        }
        
        let goalItemIsDone = !(goal.goalItems?[goalItemIndex].isDone ?? false)
        
        self.goalService?.updateGoalItem(goalItemId: itemId, goalItemContent: goalItemContent, goalItemIsDone: goalItemIsDone) { result in
            switch result {
            case .success(let newGoal):
                print("Success for itemId: \(itemId) -> new isDone:", newGoal.isDone)
                
                // Create a copy of the goalWithDetails array
                var updatedGoalsWithDetails = self.goalsWithDetails ?? []
                
                // Update the goal in the copied array
                if let index = updatedGoalsWithDetails.firstIndex(where: { $0.goalId == goal.goalId }) {
                    updatedGoalsWithDetails[index].goalItems?[goalItemIndex] = newGoal
                }
                
                // Update the original goalsWithDetails array with the copied array
                self.goalsWithDetails = updatedGoalsWithDetails
                self.reloadCard(at: indexPath)
                
            case .failure(let error):
                print("Failure for itemId: \(itemId) -> isDone cannot be updated.")
                Banner.showErrorBanner(with: error)
            }
        }
    }

    
    
}


extension GoalsNewViewController {
    func reloadCard(at indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

