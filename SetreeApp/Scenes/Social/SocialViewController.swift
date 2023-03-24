//
//  SocialViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.02.2023.
//

import UIKit

class SocialViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        textField.attributedPlaceholder = NSAttributedString(string: "Search friends..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.tooMuchLightRoyalBlueColor])
        
    }
    
    
    @IBAction func clickedSearchBtn(_ sender: Any) {
        print("jj: Search clicked: \(textField.text)")
        titleLabel.text = "Results"
    }
    


}
extension SocialViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialFriendsTableViewCell", for: indexPath) as! SocialFriendsTableViewCell
        cell.tappedUser = { [weak self] in
            guard let self = self else { return }
                if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController{
                    
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
