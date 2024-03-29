//
//  SocialViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.02.2023.
//

import UIKit
import NotificationBannerSwift

enum SocialTpe: String {
    case feed
    case search
}

class SocialViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    internal var pageType : SocialTpe? {
        didSet{
            print("----Page type: ", pageType)
            tableView.reloadData()
            switch pageType {
            case .search:
                self.titleLabel.text = "Search"
            default:
                self.titleLabel.text = "Followings"
            }
        }
    }
    
    internal var followingsArray : [User]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    internal var userSearchResult : [User]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    internal var tagSearchResult : [Tag]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    private weak var followService: FollowService?{
        return FollowService()
    }
    private weak var searchService: SearchService?{
        return SearchService()
    }
    private weak var userService: UserService?{
        return UserService()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageType = .feed
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        //self.textField.text = ""
        textField.attributedPlaceholder = NSAttributedString(string: "Search friends or #tag ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.tooMuchLightRoyalBlueColor])
        textField.delegate = self
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        
        
        initalUI()
    }
    
    func initalUI(){
        /*DispatchQueue.main.async {
            LoadingScreen.show()
        }*/
        followService?.getFollowings(){ result in
          /*  DispatchQueue.main.async {
                LoadingScreen.hide()
            }*/
            switch result {
            case .success(let followingObjects):
                //self.pageType = .feed
                self.followingsArray = followingObjects
                 
            case .failure(let error):
                let banner = GrowingNotificationBanner(title: "Try Again", subtitle: "User couldn't be loaded: \(error.localizedDescription) ", style: .warning)
                banner.show()
            }
            
        }
        
        
    }
    
    @objc func handleTap() {
        //self.pageType = .feed
        view.endEditing(true) // Close the keyboard by resigning the first responder status
    }
    
    @IBAction func clickedCancel(_ sender: Any) {
        print("jj: clickedCancel: \(textField.text)")
        self.pageType = .feed
        initalUI()
        self.textField.text = ""
        self.tagSearchResult?.removeAll()
        self.userSearchResult?.removeAll()
        
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
    


}
extension SocialViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch pageType {
        case .feed:
            return self.followingsArray?.count ?? 0
        case .search:
            return ((self.userSearchResult?.count ?? 0) + (self.tagSearchResult?.count ?? 0))
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialFriendsTableViewCell", for: indexPath) as! SocialFriendsTableViewCell
        switch pageType {
        case .feed:
            cell.followButton.isHidden = false
            cell.nameLabel.text = self.followingsArray![indexPath.row].firstName + self.followingsArray![indexPath.row].lastName
            cell.usernameLabel.text = "@" + self.followingsArray![indexPath.row].username
            cell.subInfoLabel.text = "\(self.followingsArray![indexPath.row].listCount) Lists • \(self.followingsArray![indexPath.row].followers?.count ?? 0) Followers"

           if let url = URL(string: self.followingsArray![indexPath.row].imageUrl){
                cell.userImageView.kf.setImage(with: url)
            }
            let isFollowing = self.followingsArray![indexPath.row].followers?.contains(baseUSER!.userId) ?? false
            cell.followButton.tintColor = isFollowing ? UIColor.mainRoyalBlueColor : UIColor.white
            cell.followButton.setTitleColor(isFollowing ? .white : UIColor.mainRoyalBlueColor, for: .normal)
            cell.followButton.setTitle(isFollowing ? "Following" : "Follow", for: .normal)
        
            cell.tappedUser = { [weak self] in
                guard let self = self else { return }
                    if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController{
                        vc.userId = self.followingsArray![indexPath.row].userId
                        self.navigationController?.pushViewController(vc, animated: true)
                   
                    }
                }
            
            cell.tappedFollow = {
                let isFollowing = self.followingsArray![indexPath.row].followers?.contains(baseUSER!.userId) ?? false
                
                let followAction: (Int, @escaping (Result<String, Error>) -> Void) -> Void = isFollowing ? self.unfollow : self.follow
                
                DispatchQueue.main.async {
                    LoadingScreen.show()
                }
                followAction( self.followingsArray![indexPath.row].userId) { [weak self] result in
                    DispatchQueue.main.async {
                        LoadingScreen.hide()
                    }
                    guard let self = self else { return }
                    switch result {
                    case .success(let message):
                        self.updateBaseUser()
                        self.initalUI()
                        Banner.showSuccessBanner(message: message)
                        
                        
                    case .failure(let error):
                        Banner.showErrorBanner(with: error)
                    }
                }
            
            }
        case .search:
            if indexPath.row < self.userSearchResult?.count ?? 0 {
                cell.followButton.isHidden = true
                cell.subInfoLabel.isHidden = false
                cell.nameLabel.text = self.userSearchResult![indexPath.row].firstName + self.userSearchResult![indexPath.row].lastName
                //cell.isFollowed = true
                cell.usernameLabel.text = "@" + self.userSearchResult![indexPath.row].username
                cell.subInfoLabel.text = "\(self.userSearchResult![indexPath.row].listCount) Lists • \(self.userSearchResult![indexPath.row].followers?.count ?? 0) Followers"

               if let url = URL(string: self.userSearchResult![indexPath.row].imageUrl){
                    cell.userImageView.kf.setImage(with: url)
                }
            
                
                cell.tappedUser = { [weak self] in
                    guard let self = self else { return }
                        if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController{
                            vc.userId = self.userSearchResult![indexPath.row].userId
                            self.navigationController?.pushViewController(vc, animated: true)
                       
                        }
                    }
            } else { //time to show tags
                let index = indexPath.row - (self.userSearchResult?.count ?? 0)
                cell.followButton.isHidden = true
                cell.subInfoLabel.isHidden = true
                cell.userImageView.image = UIImage(named: "tag")
//                cell.usernameLabel.font = UIFont()
                cell.nameLabel.text = "#\(self.tagSearchResult![index].title)"
                cell.usernameLabel.text = "\(tagSearchResult![index].collectionIds.count ) Collections"
                
                cell.tappedUser = { [weak self] in
                    guard let self = self else { return }
                        if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionsViewController") as? CollectionsViewController{
                            vc.type = .hashtag
                            vc.tag = self.tagSearchResult![index].title
                            vc.title = "#\(self.tagSearchResult![index].title)"
                            self.navigationController?.pushViewController(vc, animated: true)
                       
                        }
                    }
                
            }
            
        case .none:
            print("blabla")
        }
       
       
        return cell
    }
    
    
}

extension SocialViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("TextField is active")
        self.pageType = .search
        cancelButton.isHidden = false
        //titleLabel.text = "Search"
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       print("TextField is not active")
        //cancelButton.isHidden = true
   }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let keyword = textField.text else {
            return
        }
        
        let trimmedKeyword = keyword.replacingOccurrences(of: " ", with: "")
        
        // Check if the trimmed keyword length is greater than 1
        if trimmedKeyword.count > 1 {
            // Call the search service with the updated keyword
            searchService?.search(keyword: keyword) { result in
                switch result {
                case .success(let searchResponse):
                    print("Search succeeded searchResponse: \(searchResponse)")
                    self.userSearchResult = searchResponse.searchResults.users
                    self.tagSearchResult = searchResponse.searchResults.tags
                    print("that's it.")
                case .failure(let error):
                    print("Search failed: \(error)")
                }
            }
        } else {
            // Keyword is not long enough, perform other actions or show an error message
            print("Keyword is too short.")
        }
    }

    
}
