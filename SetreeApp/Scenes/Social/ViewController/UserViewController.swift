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
               self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.userListsCollectionView.contentSize.height + 480)
            }
        }
    }
    private weak var collectionService: CollectionService?{
        return CollectionService()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followersSliderCollectionView.delegate = self
        followersSliderCollectionView.dataSource = self
        followingsSliderCollectionView.delegate = self
        followingsSliderCollectionView.dataSource = self
        userListsCollectionView.delegate = self
        userListsCollectionView.dataSource = self
        initUI()
        self.view.layoutIfNeeded()
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
            if self.userId == nil {
                nameLabel.text = baseUSER.firstName + " " + baseUSER.lastName
                usernameLabel.text = "@" + baseUSER.username
                self.navigationItem.title =  baseUSER.username
                
                if let followers = baseUSER.followers {
                    followerCountLabel.text = String(followers.count)
                }
                if let followings = baseUSER.followings {
                    followingCountLabel.text = String(followings.count)
                }
                
                collectionService?.getCollections(userId: baseUSER.userId){ result in
                    switch result {
                    case .success(let collections):
                        self.collectionsArray = collections
                         
                    case .failure(let error):
                        let banner = GrowingNotificationBanner(title: "Something went wrong while retrieving the data.", subtitle: "Error: \(error.localizedDescription) ", style: .danger)
                        banner.show()

                    }
                }

            }else{
                //if user clicked to see someone else's profile -> getUser()
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.followersSliderCollectionView {
            return 11
        }else if collectionView == self.followingsSliderCollectionView {
            return 20
        }else if collectionView == self.userListsCollectionView {
            return collectionsArray?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView == self.followersSliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowersSliderCollectionViewCell", for: indexPath) as! FollowersSliderCollectionViewCell
            
            cell.tappedCell = { [weak self] in
                guard let self = self else { return }
                    if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController{
                        print("jj: tapped follower")
                        vc.userId = 113
                        self.navigationController?.pushViewController(vc, animated: true)
                   
                    }
                }
            
            return cell
        }else if collectionView == self.followingsSliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowersSliderCollectionViewCell", for: indexPath) as! FollowersSliderCollectionViewCell
            
            cell.tappedCell = { [weak self] in
                guard let self = self else { return }
                    if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController{
                        print("jj: tapped following")
                        vc.userId = 113
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            
            return cell
        }else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! CollectionsCardViewCell
            cell.bgColor = UIColor(named: collectionCardColorsArr[indexPath.row%collectionCardColorsArr.count])!
            
            cell.titleLabel.text = self.collectionsArray![indexPath.row].title
            cell.countLabel.text = "8"
            if let imageUrl = self.collectionsArray![indexPath.row].imageUrl{
                if let url = URL(string: imageUrl){
                    cell.imageView.kf.setImage(with: url)
                }
            }

            cell.tappedCell = { [weak self] in
                guard let self = self else { return }
                    if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionsDetailViewController") as? CollectionsDetailViewController{
                        vc.title = cell.titleLabel.text //update later if needed
                        vc.collectionId = 11
                        self.navigationController?.pushViewController(vc, animated: true)
                   
                    }
                }
            return cell
        }
    }
    

}
/*
*/
