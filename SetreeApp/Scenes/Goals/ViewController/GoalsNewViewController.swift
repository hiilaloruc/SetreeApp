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
        initialUI()
    }
    
    func getGoalDetails(){
        if self.goalsArray != nil && self.goalsArray?.count ?? 0 > 0 {
            
                for item in self.goalsArray! {
                    goalService?.getGoalDetail(goalId: item.goalId){ result in
                        switch result {
                        case .success(let goal ):
                            self.goalsWithDetails?.append(goal)
                             
                        case .failure(let error):
                            let banner = GrowingNotificationBanner(title: "Something went wrong while retrieving the data.", subtitle: "Error: \(error.localizedDescription) ", style: .danger)
                            banner.show()

                        }
                    }
                }
        }
    }
    
    func initialUI(){
        if let user = baseUSER{
            goalService?.getGoals(){ result in
                switch result {
                case .success(let goals):
                    self.goalsArray = goals
                    self.getGoalDetails()
                     
                case .failure(let error):
                    let banner = GrowingNotificationBanner(title: "Something went wrong while retrieving the data.", subtitle: "Error: \(error.localizedDescription) ", style: .danger)
                    banner.show()

                }
            }
        }
    }
    

}

extension GoalsNewViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = goalsWithDetails?.count ?? 0
        return min(rowCount, 6)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= 0 && indexPath.row < goalsWithDetails!.count {
            return CGFloat((64 + 8 + (goalsWithDetails![indexPath.row].goalItems?.count ?? 0 ) * 40))
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "GoalCardTableViewCell", for: indexPath) as! GoalCardTableViewCell
        cell.selectionStyle = .none
        cell.color = UIColor(named: collectionCardColorsArr[indexPath.row%collectionCardColorsArr.count])!
        cell.titleLabel.text = goalsWithDetails![indexPath.row].title
        cell.countLabel.text = String(goalsWithDetails![indexPath.row].goalItems?.count ?? 0)
        cell.goalsArray = goalsWithDetails![indexPath.row].goalItems
        
        cell.tappedCheck = { itemId in
            print("hilal işte itemId: \(itemId) ,request and get result")
            return true // Return true or false based on whether the req succces
        }
        cell.tappedGoalDetail = {
            if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "GoalsDetailViewController") as? GoalsDetailViewController{
                vc.goalObject = self.goalsWithDetails![indexPath.row]
                vc.color = cell.color
                self.navigationController?.pushViewController(vc, animated: true)
           
            }
    
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
    
    
}



