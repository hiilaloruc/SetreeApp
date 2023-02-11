//
//  FollowersSliderTableViewCell.swift
//  SetreeApp
//
//  Created by HilalOruc on 11.02.2023.
//

import UIKit

class FollowersSliderTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var followersSliderCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //followersSliderCollectionView.register(FollowersSliderCollectionViewCell.self, forCellWithReuseIdentifier: "FollowersSliderCollectionViewCell")
        followersSliderCollectionView.showsHorizontalScrollIndicator = false
        followersSliderCollectionView.delegate = self
        followersSliderCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowersSliderCollectionViewCell", for: indexPath) as! FollowersSliderCollectionViewCell
        return cell
    }
    
}
