//
//  CollectionsDetailViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 7.02.2023.
//

import UIKit

class CollectionsDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    internal var collectionId : Int?{
        didSet{
            // servisten bilgilerini çek collectionun !!
        print("jj: id declared : \(collectionId!)")
    }}

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.register(TitleHeaderTableViewCell.self, forCellReuseIdentifier: "TitleHeaderTableViewCell")
        tableView.register(UINib(nibName: "TitleHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleHeaderTableViewCell")

    }


}
extension CollectionsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let headerView = UIView()
          headerView.backgroundColor = .white
          let label = UILabel()
          label.textColor = UIColor.black
          label.font = UIFont.boldSystemFont(ofSize: 35)
          label.translatesAutoresizingMaskIntoConstraints = false
          headerView.addSubview(label)
          
          label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
          label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
          label.text = "My Title"

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleHeaderTableViewCell", for: indexPath) as! CollectionTableViewCell

        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
