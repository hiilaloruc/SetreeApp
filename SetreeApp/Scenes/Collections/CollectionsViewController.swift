//
//  CollectionsViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 3.02.2023.
//

import UIKit
import NotificationBannerSwift
import Kingfisher

enum collectionsType{
    case hashtag
    case normal
}


class CollectionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionsView: UICollectionView!
    @IBOutlet weak var plusButton: UIView!
    
    internal var type: collectionsType = .normal
    internal var tag: String?
    internal var collectionsArray : [Collection]?{
        didSet{
            collectionsView.reloadData()
        }
    }
    private weak var collectionService: CollectionService?{
        return CollectionService()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionsView.delegate = self
        collectionsView.dataSource = self
        self.plusButton.isHidden = true
        initUI()
        
        if self.type == .normal {
            self.plusButton.isHidden = false
            self.plusButton.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped))
            self.plusButton.addGestureRecognizer(tapGestureRecognizer)
            NotificationCenter.default.addObserver(self, selector: #selector(initUI), name: NSNotification.Name(rawValue: "updateCollectionsAll") , object: nil)
        }
    }
    @objc func initUI(){
        switch self.type {
        case .normal:
        if let user = baseUSER{
            /*DispatchQueue.main.async {
                LoadingScreen.show()
            }*/
            collectionService?.getCollections(userId: user.userId){ result in
               /* DispatchQueue.main.async {
                    LoadingScreen.hide()
                }*/
                switch result {
                case .success(let collections):
                    self.collectionsArray = collections
                     
                case .failure(let error):
                    Banner.showErrorBanner(with: error)
                }
            }
        }
        case .hashtag:
            if let tag = self.tag {
                DispatchQueue.main.async {
                    LoadingScreen.show()
                }
                collectionService?.getCollectionsByTag(tag: tag){ result in
                    DispatchQueue.main.async {
                        LoadingScreen.hide()
                    }
                    switch result {
                    case .success(let collections):
                        self.collectionsArray = collections
                    case .failure(let error):
                        Banner.showErrorBanner(with: error)
                    }
                }
            }
        }
            
       
    }
    
    
    @objc func plusButtonTapped(_ sender: UITapGestureRecognizer) {
        print("new collection clicked..")
        if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionCreateViewController") as? CollectionCreateViewController{
            vc.senderVC = self
            self.present(UINavigationController(rootViewController:vc), animated: true)
        }
    }
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionsArray?.count ?? 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! CollectionsCardViewCell
        cell.bgColor = UIColor(named: collectionCardColorsArr[indexPath.row%collectionCardColorsArr.count])!
        //cell.collection = self.collectionsArray![indexPath.row]
        cell.titleLabel.text = self.collectionsArray![indexPath.row].title
        //cell.countLabel.text = String(collectionsArray![indexPath.row].itemCount)
        cell.likeCountLabel.text = String(collectionsArray![indexPath.row].likeCount)
        cell.viewCountLabel.text = String(collectionsArray![indexPath.row].viewCount)
        if let url = URL(string: self.collectionsArray![indexPath.row].imageUrl){
            cell.imageView.kf.setImage(with: url)
        }

        cell.tappedCell = { [weak self] in
            guard let self = self else { return }
                if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionDetailViewController") as? CollectionDetailViewController{
                   // vc.title = cell.titleLabel.text //update later if needed
                    //vc.collectionId = 11
                    vc.collection = self.collectionsArray![indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
               
                }
            }
        return cell
    }
}

