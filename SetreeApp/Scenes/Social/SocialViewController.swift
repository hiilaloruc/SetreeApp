//
//  SocialViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.02.2023.
//

import UIKit
import NotificationBannerSwift

class SocialViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    internal var followingsArray : [User]?{
        didSet{
            tableView.reloadData()
        }
    }
    private weak var followService: FollowService?{
        return FollowService()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: "Search friends..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.tooMuchLightRoyalBlueColor])
        
        initalUI()
    }
    
    func initalUI(){
        followService?.getFollowings(){ result in
            switch result {
            case .success(let followingObjects):
                self.followingsArray = followingObjects
                 
            case .failure(let error):
                let banner = GrowingNotificationBanner(title: "Try Again", subtitle: "User couldn't be loaded: \(error.localizedDescription) ", style: .warning)
                banner.show()
            }
            
        }
        
        
    }
    
    
    @IBAction func clickedSearchBtn(_ sender: Any) {
        print("jj: Search clicked: \(textField.text)")
        titleLabel.text = "Results"
    }
    


}
extension SocialViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followingsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialFriendsTableViewCell", for: indexPath) as! SocialFriendsTableViewCell
        cell.nameLabel.text = self.followingsArray![indexPath.row].firstName + self.followingsArray![indexPath.row].lastName
        cell.isFollowed = true
        cell.usernameLabel.text = "@" + self.followingsArray![indexPath.row].username
        cell.subInfoLabel.text = "\(self.followingsArray![indexPath.row].listCount) Lists • \(self.followingsArray![indexPath.row].followers?.count ?? 0) Followers"

       if let url = URL(string: self.followingsArray![indexPath.row].imageUrl){
            cell.userImageView.kf.setImage(with: url)
        }
    
        
        cell.tappedUser = { [weak self] in
            guard let self = self else { return }
                if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController{
                    vc.userId = self.followingsArray![indexPath.row].userId
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
