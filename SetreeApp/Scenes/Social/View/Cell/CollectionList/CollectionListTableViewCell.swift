//
//  CollectionListTableViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 11.02.2023.
//

import UIKit

class CollectionListTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var userListsCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //userListsCollectionView.register(UINib(nibName: "CollectionsCardViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCollection")
        //let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! CollectionsCardViewCell
        userListsCollectionView.register(CollectionsCardViewCell.self, forCellWithReuseIdentifier: "cellCollection")
        userListsCollectionView.showsHorizontalScrollIndicator = false
        userListsCollectionView.delegate = self
        userListsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! CollectionsCardViewCell
        cell.bgColor = UIColor(named: collectionCardColorsArr[indexPath.row%collectionCardColorsArr.count])!

        cell.tappedCell = { [weak self] in
            guard let self = self else { return }
                if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionDetailViewController") as? CollectionDetailViewController{
                    vc.title = cell.titleLabel.text //update later if needed
//                    vc.collectionId = 11
                    //self.navigationController?.pushViewController(vc, animated: true)
               
                }
            }
        return cell
    }
}
