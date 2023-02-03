//
//  CollectionsViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 3.02.2023.
//

import UIKit

class CollectionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionsView: UICollectionView!
    
    override func viewDidLoad() {
        collectionsView.delegate = self
        collectionsView.dataSource = self
        super.viewDidLoad()

    }
    
    func giveMyColor(index: Int) -> String {
        let colorsArr = ["softOrange", "softLilac", "softDarkblue", "softPink", "verySoftRed", "softTurquoise" ]
        return colorsArr[index%colorsArr.count]
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! CollectionsCollectionViewCell
        cell.bgColor = UIColor(named: giveMyColor(index: indexPath.row))!
        return cell
    }
}

