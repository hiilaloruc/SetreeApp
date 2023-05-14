//
//  FullTableViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 13.05.2023.
//

import UIKit

class FullTableViewController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    internal var objectsArr : [User]? 
    internal var isFollowings : Bool = true


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
       // tableView.register(UINib(nibName: "SocialFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "SocialFriendsTableViewCell")

        self.title = isFollowings ? "Followings" : "Followers"
    }
    
}


extension FullTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialFriendsTableViewCell", for: indexPath) as! SocialFriendsTableViewCell
        
        cell.nameLabel.text = self.objectsArr![indexPath.row].firstName + self.objectsArr![indexPath.row].lastName
        cell.isFollowed = isFollowings
        cell.usernameLabel.text = "@" + self.objectsArr![indexPath.row].username
        cell.subInfoLabel.text = "\(self.objectsArr![indexPath.row].listCount) Lists • \(self.objectsArr![indexPath.row].followers?.count ?? 0) Followers"

       if let url = URL(string: self.objectsArr![indexPath.row].imageUrl){
            cell.userImageView.kf.setImage(with: url)
        }
    
        
        cell.tappedUser = { [weak self] in
            guard let self = self else { return }
                if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController{
                    vc.userId = self.objectsArr![indexPath.row].userId
                    self.navigationController?.pushViewController(vc, animated: true)
               
                }
        }
        
        cell.tappedFollow = {
            if cell.isFollowed {
                cell.followButton.tintColor = UIColor.white
                cell.followButton.setTitleColor(UIColor.mainRoyalBlueColor, for: .normal)
                cell.followButton.setTitle("Follow", for: .normal)
            } else {
                cell.followButton.tintColor = UIColor.mainRoyalBlueColor
                cell.followButton.setTitleColor(.white, for: .normal)
                cell.followButton.setTitle("Following", for: .normal)
            }
            cell.isFollowed.toggle()
        }
        return cell
    }
    
    
}
