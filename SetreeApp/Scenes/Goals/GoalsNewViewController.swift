//
//  GoalsNewViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 16.02.2023.
//

import UIKit

class GoalsNewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todoArray = [[ "Call mom and remind her medicines", "Give breakfast to Max"], ["Visit your granmda","Go to a cinema with a friend","Explore a new technology","Call a random friend","Get a certificate from any field","Enroll a course - that you know nothing"], ["Join a workshop as a part of a team", "Go stay in Poland for at least  2 weeks", "Call mom and remind her medicines", "Give breakfast to Max","Go somewhere that you never did"]]
    
    var GoalsInfoArray = [
        ["Daily","2"],
        ["Weekly","6"],
        ["Monthly","5"]
        ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "GoalCardTableViewCell", bundle: nil), forCellReuseIdentifier: "GoalCardTableViewCell")
        

        
    }
    

}

extension GoalsNewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoalsInfoArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(54 + 8 + todoArray[indexPath.row].count * 40) //50+count*40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "GoalCardTableViewCell", for: indexPath) as! GoalCardTableViewCell
        cell.titleLabel.text = GoalsInfoArray[indexPath.row][0]
        cell.countLabel.text = GoalsInfoArray[indexPath.row][1]
        cell.goalsArray = todoArray[indexPath.row]
        
        // Add the custom separator view to the bottom of the cell
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        separatorView.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
        cell.contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        
        return cell
    }
    
    
}


