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
            goalsWithDetails?.sort(by: { $0.createdAt > $1.createdAt })
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
                DispatchQueue.main.async {
                    LoadingScreen.show()
                }
                self.goalService?.createGoal(title: String(inputTitle!)){ result in
                    DispatchQueue.main.async {
                        LoadingScreen.hide()
                    }
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
                   /* DispatchQueue.main.async {
                        LoadingScreen.show()
                    }*/
                    goalService?.getGoalDetail(goalId: item.goalId){ result in
                      /*  DispatchQueue.main.async {
                            LoadingScreen.hide()
                        }*/
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
            DispatchQueue.main.async {
                LoadingScreen.show()
            }
            goalService?.getGoals(){ result in
                DispatchQueue.main.async {
                    LoadingScreen.hide()
                }
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
        return min(rowCount, 6) //limit with 6 rows step1/3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let goalsWithDetails = goalsWithDetails, indexPath.row >= 0, indexPath.row < goalsWithDetails.count else {
            return 0
        }
        
        let goalItemcount = goalsWithDetails[indexPath.row].goalItems?.count ?? 0
        let rowCount = min(goalItemcount, 6)
        let totalHeight = CGFloat(64 + 8 + (rowCount * 40) + (goalItemcount > 6 ? 20 : 0))
        
        return totalHeight
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "GoalCardTableViewCell", for: indexPath) as! GoalCardTableViewCell
        cell.selectionStyle = .none
        if let goal = goalsWithDetails?[indexPath.row] {
            cell.color = UIColor(named: collectionCardColorsArr[indexPath.row % collectionCardColorsArr.count])!
            cell.titleLabel.text = goal.title
            cell.countLabel.text = String(goal.goalItems?.count ?? 0)
            if goal.goalItems?.count ?? 0 > 6 {
                cell.showMoreNeeded = true
            }
            cell.goalsArray = Array(goal.goalItems?.prefix(6) ?? []) //limit with 6 rows  step3/3
            
            
            //cell.goalsArray = goal.goalItems
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
        DispatchQueue.main.async {
            LoadingScreen.show()
        }
        self.goalService?.updateGoalItem(goalItemId: itemId, goalItemContent: goalItemContent, goalItemIsDone: goalItemIsDone) { result in
            DispatchQueue.main.async {
                LoadingScreen.hide()
            }
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

