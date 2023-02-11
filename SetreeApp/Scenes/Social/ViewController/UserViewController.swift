//
//  UserViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 11.02.2023.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var userImageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var listCountLabel : UILabel!
    @IBOutlet weak var followerCountLabel : UILabel!
    @IBOutlet weak var followButton : UIButton!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var followersSliderCollectionView: UICollectionView!
    @IBOutlet weak var userListsCollectionView: UICollectionView!
    @IBOutlet weak var lastCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    internal var isFollowing: Bool = false
    internal var userId: Int = 112
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followersSliderCollectionView.delegate = self
        followersSliderCollectionView.dataSource = self
        
        userListsCollectionView.delegate = self
        userListsCollectionView.dataSource = self
        initUI()
        self.view.layoutIfNeeded()
    }
    
    func initUI(){
        followersSliderCollectionView.showsHorizontalScrollIndicator = false
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.mainReddishColor.cgColor
        followButton.layer.cornerRadius = 20
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.lastCollectionHeight.constant = self.userListsCollectionView.contentSize.height
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.userListsCollectionView.contentSize.height + 480)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.followersSliderCollectionView {
            return 11
        }else if collectionView == self.userListsCollectionView {
            return 11
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView == self.followersSliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowersSliderCollectionViewCell", for: indexPath) as! FollowersSliderCollectionViewCell
            
            cell.tappedCell = { [weak self] in
                guard let self = self else { return }
                    if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController{
                        print("jj: asdadadadadd2")
                        vc.userId = 113
                        self.navigationController?.pushViewController(vc, animated: true)
                   
                    }
                }
            
            return cell
        }
        else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! CollectionsCardViewCell
            cell.bgColor = UIColor(named: collectionCardColorsArr[indexPath.row%collectionCardColorsArr.count])!

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
