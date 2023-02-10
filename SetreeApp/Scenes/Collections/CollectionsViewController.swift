//
//  CollectionsViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 3.02.2023.
//

import UIKit
class CollectionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionsView: UICollectionView!
    @IBOutlet weak var plusButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionsView.delegate = self
        collectionsView.dataSource = self
        self.plusButton.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped))
        self.plusButton.addGestureRecognizer(tapGestureRecognizer)

    }
    
    @objc func plusButtonTapped(_ sender: UITapGestureRecognizer) {
        print("jj: + clicked..")
    }
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

