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
    internal var userId: Int!
    
    internal var isFollowings : Bool = true

    private weak var userService: UserService?{
        return UserService()
    }
    
    private weak var followService: FollowService?{
        return FollowService()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        self.title = isFollowings ? "Followings" : "Followers"
    }
    
    private func follow(userId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        self.followService?.follow(userId: userId, completion: completion)
    }

    private func unfollow(userId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        self.followService?.unfollow(userId: userId, completion: completion)
    }
    
    func updateBaseUser(){
        self.userService?.getUser(){ result in
            switch result {
            case .success(let user):
                baseUSER = user
                print("baseUSER : ",baseUSER)

            case .failure(let error):
                Banner.showErrorBanner(with: error)
            }
        }
    }
    
    func UpdateObjectsArr(index: [IndexPath]){
        if self.isFollowings {
            followService?.getFollowings(id:userId){ result in
                DispatchQueue.main.async {
                    LoadingScreen.hide()
                }
                switch result {
                case .success(let followingObjects):
                    self.objectsArr = followingObjects
                    self.tableView.reloadRows(at: index, with: .automatic)
                     
                case .failure(let error):
                    Banner.showErrorBanner(with: error)
                }
                
            }
        }else{
            followService?.getFollowers(id:userId){ result in
                DispatchQueue.main.async {
                    LoadingScreen.hide()
                }
                switch result {
                case .success(let followersObjects):
                    self.objectsArr = followersObjects
                    self.tableView.reloadRows(at: index, with: .automatic)
                     
                case .failure(let error):
                    Banner.showErrorBanner(with: error)
                }
                
            }
        }
    }
}


extension FullTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialFriendsTableViewCell", for: indexPath) as! SocialFriendsTableViewCell
        
        cell.nameLabel.text = self.objectsArr![indexPath.row].firstName + self.objectsArr![indexPath.row].lastName
        cell.usernameLabel.text = "@" + self.objectsArr![indexPath.row].username
        cell.subInfoLabel.text = "\(self.objectsArr![indexPath.row].listCount) Lists • \(self.objectsArr![indexPath.row].followers?.count ?? 0) Followers"
        
        let isFollowing = self.objectsArr![indexPath.row].followers?.contains(baseUSER!.userId) ?? false
        cell.followButton.tintColor = isFollowing ? UIColor.mainRoyalBlueColor : UIColor.white
        cell.followButton.setTitleColor(isFollowing ? .white : UIColor.mainRoyalBlueColor, for: .normal)
        cell.followButton.setTitle(isFollowing ? "Following" : "Follow", for: .normal)
    

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
            let isFollowing =  self.objectsArr![indexPath.row].followers?.contains(baseUSER!.userId) ?? false
            
            let followAction: (Int, @escaping (Result<String, Error>) -> Void) -> Void = isFollowing ? self.unfollow : self.follow
            
            DispatchQueue.main.async {
                LoadingScreen.show()
            }
            followAction(  self.objectsArr![indexPath.row].userId) { [weak self] result in
               
                DispatchQueue.main.async {
                    LoadingScreen.hide()
                }
                guard let self = self else { return }
                switch result {
                case .success(let message):
                    self.UpdateObjectsArr(index: [IndexPath(item: indexPath.row, section: 0)])
                    self.updateBaseUser()
                    Banner.showSuccessBanner(message: message)
                    
                case .failure(let error):
                    Banner.showErrorBanner(with: error)
                }
            }
        
        }
        return cell
    }
    
    
}
