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
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        self.textField.text = ""
        textField.attributedPlaceholder = NSAttributedString(string: "Search friends..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.tooMuchLightRoyalBlueColor])
        textField.delegate = self
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        
        
        initalUI()
    }
    
    func initalUI(){
        followService?.getFollowings(){ result in
            switch result {
            case .success(let followingObjects):
                self.pageType = .feed
                self.followingsArray = followingObjects
                 
            case .failure(let error):
                let banner = GrowingNotificationBanner(title: "Try Again", subtitle: "User couldn't be loaded: \(error.localizedDescription) ", style: .warning)
                banner.show()
            }
            
        }
        
        
    }
    
    @objc func handleTap() {
        self.pageType = .feed
        view.endEditing(true) // Close the keyboard by resigning the first responder status
    }
    
    @IBAction func clickedCancel(_ sender: Any) {
        print("jj: clickedCancel: \(textField.text)")
        self.textField.text = ""
        self.tagSearchResult?.removeAll()
        self.userSearchResult?.removeAll()
        self.pageType = .feed
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
                
                /*cell.tappedUser = { [weak self] in
                    guard let self = self else { return }
                        if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionsViewController") as? CollectionsViewController{
                            vc.type = .hashtag
                            vc.tag = self.tagSearchResult![index].title
                            vc.title = "#\(self.tagSearchResult![index].title)"
                            self.navigationController?.pushViewController(vc, animated: true)
                       
                        }
                    }*/
                
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
        cancelButton.isHidden = true
   }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let keyword = textField.text else {
            return
        }
        
        let trimmedKeyword = keyword.replacingOccurrences(of: " ", with: "")
        
        // Check if the trimmed keyword length is greater than 2
        if trimmedKeyword.count > 2 {
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
