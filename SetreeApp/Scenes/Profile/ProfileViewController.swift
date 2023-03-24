//
//  ProfileViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 24.03.2023.
//

import UIKit
let genders = ["Male", "Female", "Other"]

class ProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var genderPickerView: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(clickedSave))
    }
    
    @objc func clickedSave() {
        //update operations to be handled
        print("clicked save")
    }
    @IBAction func clickedEditImage(_ sender: Any){
        print("clickedEditImage..")
    }
    
    @IBAction func clickedChangePassword(_ sender: Any){
        print("clickedChangePassword..")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }

    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = genders[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedGender = genders[row]
        print("Selected gender: \(selectedGender)")
    }


}
