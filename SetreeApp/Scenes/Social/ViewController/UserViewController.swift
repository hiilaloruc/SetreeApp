//
//  UserViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 11.02.2023.
//

import UIKit
import NotificationBannerSwift

class UserViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var userImageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var listCountLabel : UILabel!
    @IBOutlet weak var followerCountLabel : UILabel!
    @IBOutlet weak var followingCountLabel : UILabel!
    @IBOutlet weak var followOrEditButton : UIButtonX!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var followersSliderCollectionView: UICollectionView!
    @IBOutlet weak var followingsSliderCollectionView: UICollectionView!
    @IBOutlet weak var userListsCollectionView: UICollectionView!
    @IBOutlet weak var lastCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    internal var isFollowed: Bool = true
    internal var userId: Int? = nil
    
    internal var collectionsArray : [Collection]?{
        didSet{
            userListsCollectionView.reloadData()
            DispatchQueue.main.async {
               self.lastCollectionHeight.constant = self.userListsCollectionView.contentSize.height
               self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.userListsCollectionView.contentSize.height + 530)
            }
        }
    }
    
    internal var followersArray: [User]? {
        didSet{
            followersSliderCollectionView.reloadData()
        }
    }
    
    internal var followingsArray: [User]? {
        didSet{
            followingsSliderCollectionView.reloadData()
        }
    }
    
    private weak var collectionService: CollectionService?{
        return CollectionService()
    }
    private weak var userService: UserService?{
        return UserService()
    }
    private weak var followService : FollowService?{
        return FollowService()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        followersSliderCollectionView.delegate = self
        followersSliderCollectionView.dataSource = self
        followingsSliderCollectionView.delegate = self
        followingsSliderCollectionView.dataSource = self
        userListsCollectionView.delegate = self
        userListsCollectionView.dataSource = self
        initUI()
        self.view.layoutIfNeeded()
    }
    
    func updateUI(with user: User) {
        userImageView.kf.setImage(with: URL(string: user.imageUrl))
        nameLabel.text = user.firstName + " " + user.lastName
        usernameLabel.text = "@" + user.username
        listCountLabel.text = String(user.listCount)
        self.navigationItem.title = user.username
        
        followerCountLabel.text = String(user.followers?.count ?? 0)
        followingCountLabel.text = String(user.followings?.count ?? 0)
    }
    
    func loadUser(with id: Int) {
        userService?.getUser(id: id){ [weak self] result in
            switch result {
            case .success(let user):
                self?.updateUI(with: user)
                self?.getCollections(for: user)
                self?.getFollowings(for: user)
                self?.getFollowers(for: user)
                
                 
            case .failure(let error):
                let banner = GrowingNotificationBanner(title: "Try Again", subtitle: "User couldn't be loaded: \(error.localizedDescription) ", style: .warning)
                banner.show()
            }
        }
    }
    
    
    
    func getCollections(for user: User) {
        collectionService?.getCollections(userId: user.userId){ [weak self] result in
            switch result {
            case .success(let collections):
                self?.collectionsArray = collections
                 
            case .failure(let error):
                let banner = GrowingNotificationBanner(title: "Oh no!", subtitle: "Error: \(error.localizedDescription) ", style: .danger)
                banner.show()
            }
        }
    }
    func getFollowers(for user: User){
        followService?.getFollowers(id:user.userId){ [weak self] result in
            switch result {
            case .success(let followersResponse):
                self?.followersArray = followersResponse
                 
            case .failure(let error):
                let banner = GrowingNotificationBanner(title: "Oh no!", subtitle: "Error: \(error.localizedDescription) ", style: .danger)
                banner.show()
            }
        }
    }
    
    func getFollowings(for user: User){
        //get followings
        followService?.getFollowings(id:user.userId){ [weak self] result in
            switch result {
            case .success(let followingsResponse):
                self?.followingsArray = followingsResponse
                 
            case .failure(let error):
                let banner = GrowingNotificationBanner(title: "Oh no!", subtitle: "Error: \(error.localizedDescription) ", style: .danger)
                banner.show()
            }
        }
    }
    
    
    func initUI(){
        followOrEditButton.tintColor = UIColor.mainRoyalBlueColor
        followersSliderCollectionView.showsHorizontalScrollIndicator = false
        followingsSliderCollectionView.showsHorizontalScrollIndicator = false
        setButtonView()
     /*   followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.mainRoyalBlueColor.cgColor
        followButton.layer.cornerRadius = 20
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)*/
        if let baseUSER = baseUSER {
            if let userId = self.userId {
                //if user clicked to see someone else's profile -> getUser()
                loadUser(with: userId)
            } else {
                updateUI(with: baseUSER)
                getCollections(for: baseUSER)
                getFollowings(for: baseUSER)
                getFollowers(for: baseUSER)
            }
        }
        
    }
    
    
    //override func viewDidAppear(_ animated: Bool) {
        //self.lastCollectionHeight.constant = self.userListsCollectionView.contentSize.height
        //self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.userListsCollectionView.contentSize.height + 480)
    //}
    func updateFollowButtonView(){
        if self.isFollowed {
            followOrEditButton.tintColor = UIColor.mainRoyalBlueColor
            followOrEditButton.setTitleColor(.white, for: .normal)
            followOrEditButton.setTitle("Following", for: .normal)
        } else {
            followOrEditButton.tintColor = UIColor.white
            followOrEditButton.setTitleColor(UIColor.mainRoyalBlueColor, for: .normal)
            followOrEditButton.setTitle("Follow", for: .normal)
            
        }
    }
    
    func setButtonView(){
        //that button can be either edit profile - follow,unfollow according to authUser
        if self.userId == nil {
            followOrEditButton.tintColor = UIColor.white
            followOrEditButton.setTitleColor(UIColor.mainRoyalBlueColor, for: .normal)
            followOrEditButton.setTitle("Edit Profile", for: .normal)
        }else{
            updateFollowButtonView()
        }
    }
    
    @IBAction func followOrEditButtonClicked(_ sender: Any) {
        print("jj: clicked follow Current: \(isFollowed)")
        
        if self.userId == nil {
         //navigate to profileVC
            print("edit profile clicked")
            if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController{
                self.navigationController?.pushViewController(vc, animated: true)
           
            }
            
        }else{
            self.isFollowed.toggle()
            updateFollowButtonView()
            print("jj: clicked follow new: \(isFollowed)")
        }
        
    }
    
    @IBAction func FollowersClicked(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FullTableViewController") as? FullTableViewController{
            vc.isFollowings = false
            vc.objectsArr = self.followersArray
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func FollowingsClicked(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FullTableViewController") as? FullTableViewController{
            vc.isFollowings = true
            vc.objectsArr = self.followingsArray
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    private func followCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, followArray: [User]) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowersSliderCollectionViewCell", for: indexPath) as! FollowersSliderCollectionViewCell
        
        cell.userImageView.kf.setImage(with: URL(string: followArray[indexPath.row].imageUrl))
        
        cell.tappedCell = { [weak self] in
            guard let self = self else { return }
            if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController{
                if collectionView == self.followersSliderCollectionView {
                    print("tapped follower name(id): \(followArray[indexPath.row].firstName)(\(followArray[indexPath.row].userId))")
                } else if collectionView == self.followingsSliderCollectionView {
                    print("tapped following name(id):\(followArray[indexPath.row].firstName)(\(followArray[indexPath.row].userId))")
                }
                vc.userId = followArray[indexPath.row].userId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.followersSliderCollectionView {
            return followersArray?.count ?? 0
        }else if collectionView == self.followingsSliderCollectionView {
            return followingsArray?.count ?? 0
        }else if collectionView == self.userListsCollectionView {
            return collectionsArray?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.followersSliderCollectionView {
              return followCollectionViewCell(collectionView: collectionView, indexPath: indexPath, followArray: self.followersArray!)
          } else if collectionView == self.followingsSliderCollectionView {
              return followCollectionViewCell(collectionView: collectionView, indexPath: indexPath, followArray: self.followingsArray!)
          }else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! CollectionsCardViewCell
            cell.bgColor = UIColor(named: collectionCardColorsArr[indexPath.row%collectionCardColorsArr.count])!
            
            cell.titleLabel.text = self.collectionsArray![indexPath.row].title
            cell.countLabel.text = String(collectionsArray![indexPath.row].itemCount)
            cell.likeCountLabel.text = String(collectionsArray![indexPath.row].likeCount)
            cell.viewCountLabel.text = String(collectionsArray![indexPath.row].viewCount)
            if let url = URL(string: self.collectionsArray![indexPath.row].imageUrl){
                cell.imageView.kf.setImage(with: url)
            }


            cell.tappedCell = { [weak self] in
                guard let self = self else { return }
                    if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionsDetailViewController") as? CollectionsDetailViewController{
                        vc.title = cell.titleLabel.text //update later if needed
                        vc.collectionId = 11
                        vc.collection = self.collectionsArray![indexPath.row]
                        self.navigationController?.pushViewController(vc, animated: true)
                   
                    }
                }
            return cell
        }
    }
    

}
/*
*/
