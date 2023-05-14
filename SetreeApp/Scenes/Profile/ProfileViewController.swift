//
//  ProfileViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 24.03.2023.
//

import UIKit
import NotificationBannerSwift
let genders = ["Male", "Female", "Other"]

class ProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var genderPickerView: UIPickerView!
    
    private weak var userService: UserService?{
        return UserService()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(clickedSave))
        self.firstnameTextField.becomeFirstResponder()
        if let user = baseUSER {
            self.firstnameTextField.text = user.firstName
            self.surnameTextField.text = user.lastName
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            if user.gender == "other" {
                self.genderPickerView.selectRow(2, inComponent: 0, animated: true)
            }else if user.gender == "female" {
                self.genderPickerView.selectRow(1, inComponent: 0, animated: true)
            }else{
                self.genderPickerView.selectRow(0, inComponent: 0, animated: true)
            }
            

            let isoDateString = user.createdAt
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: isoDateString) {
                dateFormatter.dateFormat = "dd.MM.yy HH:mm"
                let formattedDate = dateFormatter.string(from: date)
                self.createdAtLabel.text = ("Account created at: \(formattedDate)" )
            }

            
            
            
           
        }
    }
    
    func getFormattedTime(time:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let formattedDate = dateFormatter.string(from: dateFormatter.date(from: time)!)
        return formattedDate
    }
    
    @objc func clickedSave() {
        //update operations to be handled
        print("clicked save")
        if self.genderPickerView.selectedRow(inComponent: 0) == 2{
           //other
            updateUser(gender: "other")
        }else if self.genderPickerView.selectedRow(inComponent: 0) == 1 {
            //female
            updateUser(gender: "female")
        }else{
            //male
            updateUser(gender: "male")
        }
        
        
    }
    func updateUser(gender: String ){
        print("firstName: \(self.firstnameTextField.text ?? "") \n lastName: \(self.surnameTextField.text ?? "") \n username: \(self.usernameTextField.text ?? "") \n email: \(self.emailTextField.text ?? "") \n gender: \(gender) \n ")
        userService?.updateUser(firstName: self.firstnameTextField.text ?? "", lastName: self.surnameTextField.text ?? "", username: self.usernameTextField.text ?? "", email: self.emailTextField.text ?? "", gender: gender){ result in
            switch result {
            case .success(let user):
                print("User is successfully updated -> USER: \(user)")
                // Perform here the actions to be taken when the user is successfully updated
                baseUSER = user
                let banner = GrowingNotificationBanner(title: "Success", subtitle: "Your account has been successfully updated.", style: .success)
                banner.show()
                self.navigationController?.popViewController(animated: true)

            case .failure(let error):
                print("The user could not be updated. ERROR: \(error.localizedDescription)")
                // Perform here the actions to be taken when the user is not updated
                let banner = GrowingNotificationBanner(title: "Error", subtitle: "\(error.localizedDescription).", style: .danger)
                banner.show()
            }
        }
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
