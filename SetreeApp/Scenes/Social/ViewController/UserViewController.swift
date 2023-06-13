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
    
    
   //internal var isFollowed: Bool = true
    internal var userId: Int? = nil // if userId is not nil it means you are someone else's profile (not yourself).
    internal var profileUser: User?
    
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
        
        if let isFollowing = user.followers?.contains(baseUSER!.userId), isFollowing {
            updateFollowButtonView(isFollowing: true)
        } else {
            updateFollowButtonView(isFollowing: false)
        }
        
    }
    
    func loadUser(with id: Int) {
        DispatchQueue.main.async {
            LoadingScreen.show()
        }
        userService?.getUser(id: id){ [weak self] result in
            DispatchQueue.main.async {
                LoadingScreen.hide()
            }
            switch result {
            case .success(let user):
                self?.profileUser = user
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
       /* DispatchQueue.main.async {
            LoadingScreen.show()
        }*/
        collectionService?.getCollections(userId: user.userId){ [weak self] result in
           /* DispatchQueue.main.async {
                LoadingScreen.hide()
            }*/
            switch result {
            case .success(let collections):
                self?.collectionsArray = collections
                 
            case .failure(let error):
                Banner.showErrorBanner(with: error)
            }
        }
    }
    func getFollowers(for user: User){
        /*DispatchQueue.main.async {
            LoadingScreen.show()
        }*/
        followService?.getFollowers(id:user.userId){ [weak self] result in
           /* DispatchQueue.main.async {
                LoadingScreen.hide()
            }*/
            switch result {
            case .success(let followersResponse):
                self?.followersArray = followersResponse
                 
            case .failure(let error):
                Banner.showErrorBanner(with: error)
            }
        }
    }
    
    func getFollowings(for user: User){
        /*DispatchQueue.main.async {
            LoadingScreen.show()
        }*/
        //get followings
        followService?.getFollowings(id:user.userId){ [weak self] result in
           /* DispatchQueue.main.async {
                LoadingScreen.hide()
            }*/
            switch result {
            case .success(let followingsResponse):
                self?.followingsArray = followingsResponse

            case .failure(let error):
                Banner.showErrorBanner(with: error)
            }
        }
    }
    
    
    func initUI(){
        followOrEditButton.tintColor = UIColor.mainRoyalBlueColor
        followersSliderCollectionView.showsHorizontalScrollIndicator = false
        followingsSliderCollectionView.showsHorizontalScrollIndicator = false
        
        if let baseUSER = baseUSER {
            if let userId = self.userId {
                //if user clicked to see someone else's profile -> loadUser()
                loadUser(with: userId)
            } else {
                updateUI(with: baseUSER)
                getCollections(for: baseUSER)
                getFollowings(for: baseUSER)
                getFollowers(for: baseUSER)
                followOrEditButton.tintColor = UIColor.white
                followOrEditButton.setTitleColor(UIColor.mainRoyalBlueColor, for: .normal)
                followOrEditButton.setTitle("Edit Profile", for: .normal)
            }
        }
        
    }
    
    
    //override func viewDidAppear(_ animated: Bool) {
        //self.lastCollectionHeight.constant = self.userListsCollectionView.contentSize.height
        //self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.userListsCollectionView.contentSize.height + 480)
    //}
    func updateFollowButtonView(isFollowing: Bool!){
        if isFollowing {
            followOrEditButton.tintColor = UIColor.mainRoyalBlueColor
            followOrEditButton.setTitleColor(.white, for: .normal)
            followOrEditButton.setTitle("Following", for: .normal)
        } else {
            followOrEditButton.tintColor = UIColor.white
            followOrEditButton.setTitleColor(UIColor.mainRoyalBlueColor, for: .normal)
            followOrEditButton.setTitle("Follow", for: .normal)
            
        }
    }
    
    @IBAction func followOrEditButtonClicked(_ sender: Any) {
        
        if self.userId == nil {
         //navigate to profileVC
            print("edit profile clicked")
            if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController{
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            guard let profileUser = self.profileUser else {
                print("No profile user found.")
                return
            }

            let isFollowing = profileUser.followers?.contains(baseUSER!.userId) ?? false

            let followAction: (Int, @escaping (Result<String, Error>) -> Void) -> Void = isFollowing ? self.unfollow : self.follow
            
            DispatchQueue.main.async {
                LoadingScreen.show()
            }
            followAction(profileUser.userId) { [weak self] result in
               
                DispatchQueue.main.async {
                    LoadingScreen.hide()
                }
                guard let self = self else { return }
                switch result {
                case .success(let message):
                    self.updateBaseUser()
                    self.updateFollowButtonView(isFollowing: !isFollowing)
                    self.loadUser(with: profileUser.userId)
                    Banner.showSuccessBanner(message: message)
                case .failure(let error):
                    Banner.showErrorBanner(with: error)
                }
            }
        }
        
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
    
    @IBAction func FollowersClicked(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FullTableViewController") as? FullTableViewController{
            vc.isFollowings = false
            
            if let userid = self.userId {
                vc.userId = userid
            }else{
                vc.userId = baseUSER?.userId
            }
           
            vc.objectsArr = self.followersArray
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func FollowingsClicked(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FullTableViewController") as? FullTableViewController{
            vc.isFollowings = true
            
            if let userid = self.userId {
                vc.userId = userid
            }else{
                vc.userId = baseUSER?.userId
            }
           
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
            //cell.countLabel.text = String(collectionsArray![indexPath.row].itemCount)
            cell.likeCountLabel.text = String(collectionsArray![indexPath.row].likeCount)
            cell.viewCountLabel.text = String(collectionsArray![indexPath.row].viewCount)
            if let url = URL(string: self.collectionsArray![indexPath.row].imageUrl){
                cell.imageView.kf.setImage(with: url)
            }
            /*let imageUrl = self.collectionsArray![indexPath.row].imageUrl
              if imageUrl.hasPrefix("https") {
                  // Regular URL
                  if let url = URL(string: imageUrl) {
                      print("jjj: image URL format")
                      cell.imageView.kf.setImage(with: url)
                  }
              } else if imageUrl.hasPrefix("data:image") {
                  // Base64-encoded image URL
                  if let base64String = imageUrl.components(separatedBy: ",").last,
                      let base64Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
                      let image = UIImage(data: base64Data) {
                      print("jjj: image base64Data format")
                      cell.imageView.image = image
                  }
              }*/
              


            cell.tappedCell = { [weak self] in
                guard let self = self else { return }
                    if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionDetailViewController") as? CollectionDetailViewController{
                        vc.title = cell.titleLabel.text //update later if needed
                        //vc.collectionId = 11
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
