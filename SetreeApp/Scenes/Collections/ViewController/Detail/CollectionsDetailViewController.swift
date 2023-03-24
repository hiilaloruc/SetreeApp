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
        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        tableView.separatorStyle = .none

        let customPlusButton = plusBtnView.init(frame: .init(x: 0, y: 0, width: 44, height: 44))
        customPlusButton.tappedPlusBtn = { [weak self] in
           print("jj: tappedPlusBtn handling..")
           /* guard let self = self else { return }
                if let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CollectionsDetailViewController") as? CollectionsDetailViewController{
                    vc.title = cell.titleLabel.text //update later if needed
                    vc.collectionId = 11
                    self.navigationController?.pushViewController(vc, animated: true)
               
                }*/
            }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customPlusButton)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
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
