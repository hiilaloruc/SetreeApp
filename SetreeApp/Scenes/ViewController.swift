//
//  ViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 3.02.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("jj: Hello World!")
    }


}

extension UIViewController { // REMOVE  TEXT FROM BACK BUTTON ON NAVIGATION
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        navigationItem.backButtonDisplayMode = .minimal
        return super.awakeAfter(using: coder)
    }
}
