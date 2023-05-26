//
//  CollectionDetailViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 26.05.2023.
//

import UIKit

class CollectionDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    internal var collection: Collection!{
        didSet{
            //self.tableView.reloadData()
           /* DispatchQueue.main.async {
               self.lastCollectionHeight.constant = self.tableView.contentSize.height
               self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.tableView.contentSize.height + 300)
            }*/
        }
    }
    
    internal var collectionId : Int?{
        didSet{
        print("collectionId declared : \(collectionId!)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        tableView.register(UINib(nibName: "CollectionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionHeaderTableViewCell")
        tableView.separatorStyle = .none
        self.tableView.reloadData()
    
            
        
        // Add the Options button with three-dot icon to the navigation bar
         let optionsButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionsButtonTapped))
         navigationItem.rightBarButtonItem = optionsButton
        
        if let url = URL(string: self.collection.imageUrl){
            self.imageView.kf.setImage(with: url)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newvalue = change?[.newKey]{
                let newsize = newvalue as! CGSize
                self.tableViewHeight.constant = newsize.height
            }
        }
    }
    
    @objc func optionsButtonTapped() {
        print("optionsButtonTapped")
    }

}

extension CollectionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionHeaderTableViewCell", for: indexPath) as! CollectionHeaderTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 20
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
     }*/
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Sil") { (action, indexPath) in
            // silme işlemini gerçekleştir
            print("silme işlemini gerçekleştir")
        }
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // silme işlemini gerçekleştir
            print("silme işlemini gerçekleştir2")
        }
    }
    
}
