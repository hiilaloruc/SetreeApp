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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        textField.attributedPlaceholder = NSAttributedString(string: "Search friends..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.tooMuchLightRed])
        
    }
    
    
    @IBAction func clickedSearchBtn(_ sender: Any) {
        print("jj: Search clicked: \(textField.text)")
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
                if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController{
                    
                    self.navigationController?.pushViewController(vc, animated: true)
               
                }
            }
        return cell
    }
    
    
}
