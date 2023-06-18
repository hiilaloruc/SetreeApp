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
    @IBOutlet weak var likeBtn: UIImageView!
    
    internal var collection: Collection!{
        didSet{
            //self.tableView.reloadData()
           /* DispatchQueue.main.async {
               self.lastCollectionHeight.constant = self.tableView.contentSize.height
               self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.tableView.contentSize.height + 300)
            }*/
        }
    }
    
    internal var collectionItemsArray: [CollectionItem]?{
        didSet{
            self.tableView.reloadData()
        }
    }

    private weak var collectionService : CollectionService? {
        return CollectionService()
    }
    private weak var userService : UserService? {
        return UserService()
    }
    private weak var followService: FollowService? {
        return FollowService()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        tableView.register(UINib(nibName: "CollectionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionHeaderTableViewCell")
        tableView.separatorStyle = .none
        
        initUI()
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        self.tableView.tableFooterView = footerView
        
        // Add the Options button with three-dot icon to the navigation bar
         let optionsButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionsButtonTapped))
         navigationItem.rightBarButtonItem = optionsButton
        
        if let url = URL(string: self.collection.imageUrl){
            self.imageView.kf.setImage(with: url)
        }
        
        
        likeBtn.isUserInteractionEnabled = true
        likeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hearthClicked)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
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
    
    func initUI(){
        self.title = collection.title
        self.collectionItemsArray?.removeAll()
        
        if let baseUser = baseUSER {
            if collection.userId == baseUser.userId {
                likeBtn.isHidden = true
            } else {
                likeBtn.isHidden = false
                likeBtn.layer.shadowColor = UIColor.black.cgColor
                likeBtn.layer.shadowOpacity = 0.8
                likeBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
                likeBtn.layer.shadowRadius = 3
                
                if let likedCollections = baseUser.likedCollections {
                    likeBtn.tintColor = likedCollections.contains(collection.collectionId) ? .systemRed : .systemGray5
                }
            }
        }
       
        
        self.getCollectionItemsArr()
    }
    
    func getCollectionItemsArr(){
        DispatchQueue.main.async {
            LoadingScreen.show()
        }
        self.collectionService?.getItemsByCollection(collectionId: self.collection.collectionId ){ result in
            DispatchQueue.main.async {
                LoadingScreen.hide()
            }
            switch(result){
            case .success(let collectionItemsArray):
                self.collectionItemsArray = collectionItemsArray
                
            case .failure(let error):
                Banner.showErrorBanner(with: error)
            }
        }
    }
    
    @objc func hearthClicked(){
        //hearth tapped-> like or dislike
        
        if baseUSER != nil, baseUSER?.likedCollections != nil {
            if baseUSER!.likedCollections!.contains(self.collection.collectionId){
                print("Dislike operation is starting..")
                self.collectionService?.dislikeCollection(collectionId: collection.collectionId){ result in
                    switch result {
                    case .success(let message):
                        self.updateBaseUser()
                        self.updateCollection()
                        self.likeBtn.tintColor = .systemGray5
                        
                    case .failure(let error):
                        Banner.showErrorBanner(with: error)
                    }
                }
                
                
            }else{
                print("Like operation is starting..")
                self.collectionService?.likeCollection(collectionId: collection.collectionId){ result in
                    switch result {
                    case .success(let message):
                        self.updateBaseUser()
                        self.updateCollection()
                        self.likeBtn.tintColor = .systemRed
                    case .failure(let error):
                        Banner.showErrorBanner(with: error)
                    }
                }
            }
        }
        
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
    func updateCollection(){
        self.collectionService?.getCollection(collectionId: self.collection.collectionId){ result in
            switch result {
            case .success(let collection):
                self.collection = collection
                //tableView reload header(section 0)
                self.tableView.reloadSections([0], with: .none)
                print("collection : ",collection)

            case .failure(let error):
                Banner.showErrorBanner(with: error)
            }
        }
    }
    
    @objc func optionsButtonTapped() {
        print("optionsButtonTapped")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.deleteItem()
        }
        alertController.addAction(deleteAction)
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { (_) in
            self.updateItem()
        }
        alertController.addAction(updateAction)
        
       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       alertController.addAction(cancelAction)
        
        // Configure popover presentation for iPad
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.barButtonItem = navigationItem.rightBarButtonItem
            popoverPresentationController.permittedArrowDirections = .up
        }
        
        // Present the alertController
        present(alertController, animated: true, completion: nil)
    }
    func deleteItem() {
        // Delete action implementation
        print("Delete action tapped")
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Delete Collection", message: "Are you sure you want to delete collection?", preferredStyle: .alert)

        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Yes", style: .destructive) { _ in

            // this code runs when the user hits the "save" button
            DispatchQueue.main.async {
                LoadingScreen.show()
            }
            self.collectionService?.deleteCollection(collectionId: self.collection.collectionId){ result in
                DispatchQueue.main.async {
                    LoadingScreen.hide()
                }
                  switch result {
                  case .success(let message):
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCollectionsAll"), object: nil)
                  case .failure(let error):
                      Banner.showErrorBanner(with: error)
                  }
              }
              print("Deleted Collection GROUP")
            self.navigationController?.popViewController(animated: true)
          

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
        
        
        
    }

    func updateItem() {
        // Update action implementation
        print("Update action tapped")
    }

}

extension CollectionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.collectionItemsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionHeaderTableViewCell", for: indexPath) as! CollectionHeaderTableViewCell
            //cell.titleLabel.text = self.collection.title
            cell.likeCountLabel.text = String(self.collection.likeCount)
            cell.viewCountLabel.text = String(self.collection.viewCount)
            if self.collection.userId != baseUSER?.userId {
                cell.editStackView.isHidden = true // someone else's collection
            }else {
                cell.editStackView.isHidden = false // my own collection
            }
            
            if let tag = self.collection.tag {
                cell.tagLabel.text = "#\(tag)"
            }
            if self.collection.isPublic {
                cell.isPublicButton.setTitle("Public ", for: .normal)
                cell.isPublicButton.setImage( UIImage(systemName: "lock.open.fill"), for: .normal)
                cell.isPublicButton.tintColor = UIColor(named: "softGreen")
            }else{
                cell.isPublicButton.setTitle("Private ", for: .normal)
                cell.isPublicButton.setImage( UIImage(systemName: "lock.fill"), for: .normal)
                cell.isPublicButton.tintColor = UIColor.systemGray4
            }
            
            cell.addNewItemClicked = {  itemType in
                if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionitemCreateViewController") as? CollectionitemCreateViewController{
                    vc.itemType = itemType
                    vc.createTextOrTitle = {  type, content in
                        print("Type: \(type), Content: \(content)")
                        
                        self.collectionService?.createCollectionItem(content: content, type: type, collectionId: self.collection.collectionId) {result in
                            switch result {
                            case .success(let collectionItem):
                                Banner.showSuccessBanner(message: "Item successfully created")
                                self.collectionItemsArray?.append(collectionItem)
                                
                            case .failure(let error):
                                Banner.showErrorBanner(with: error)
                            }
                        }
                    }
                    
                    
                    self.present(UINavigationController(rootViewController:vc), animated: true)
                }
            }
            
            
            return cell
        }else{
            let collectionItem = self.collectionItemsArray![indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
            configureCell(cell, with: collectionItem)
            return cell
        }
    }
    
    
    func configureCell(_ cell: CollectionTableViewCell, with collectionItem: CollectionItem) {
        cell.titleLabel.isHidden = false
        cell.userImageView.isHidden = false
        cell.titleLabel.text = collectionItem.content
        if collectionItem.type == "image" {
            // Load image and hide/show appropriate views
            cell.titleLabel.isHidden = true
            cell.userImageView.kf.setImage(with: URL(string: collectionItem.content))
        } else {
            // Show text content
            cell.userImageView.image = nil
        }
        
        cell.titleLabel.font = collectionItem.type == "title" ? UIFont.boldSystemFont(ofSize: 18) : UIFont.sfLight(ofSize: 15)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if self.collection.userId != baseUSER?.userId {
                return 90 // someone else's collection
            }
            return 125
        }
        if indexPath.section == 1{
            let collectionItem = self.collectionItemsArray![indexPath.row]
            if (collectionItem.type == "image"){
                return 200
            }
        }
        
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in

            print("perform delete operation, row \(indexPath.row) , item: \(self.collectionItemsArray![indexPath.row].content)")
            DispatchQueue.main.async {
                LoadingScreen.show()
            }
            self.collectionService?.deleteCollectionItem(collectionItemId: self.collectionItemsArray![indexPath.row].collectionItemId){ result in
                DispatchQueue.main.async {
                    LoadingScreen.hide()
                }
                switch result {
                case .success(let message ):
                    self.initUI()
                case .failure(let error):
                    Banner.showErrorBanner(with: error)
                }
            }
            
        }
        
        let updateAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in

            print("perform update operation, row: \(indexPath.row), item: \(self.collectionItemsArray![indexPath.row].content)")
            if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionitemCreateViewController") as? CollectionitemCreateViewController{
                let itemTypeString = self.collectionItemsArray![indexPath.row].type
                if let itemType = CollectionItemType(rawValue: itemTypeString) {
                    vc.itemType = itemType
                    vc.itemToUpdate = self.collectionItemsArray![indexPath.row]
                }
                
                vc.createTextOrTitle = {  type, content in
                    print("Type: \(type), Content: \(content)")
                    
                    self.collectionService?.updateCollectionItem(content: content, collectionItemId: self.collectionItemsArray![indexPath.row].collectionItemId) {result in
                        switch result {
                        case .success(let collectionItem):
                            Banner.showSuccessBanner(message: "Item successfully updated")
                            self.getCollectionItemsArr()
                            
                        case .failure(let error):
                            Banner.showErrorBanner(with: error)
                        }
                    }
                }
                
                self.present(UINavigationController(rootViewController:vc), animated: true)
            }
            
            
          }
          
          return [ updateAction,deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // silme işlemini gerçekleştir
            print("silme işlemini gerçekleştir2")
        }else if editingStyle == .insert {
            // Güncelleme işlemini gerçekleştir
            print("Güncelleme işlemini gerçekleştir2")
        }
    }
    
}
