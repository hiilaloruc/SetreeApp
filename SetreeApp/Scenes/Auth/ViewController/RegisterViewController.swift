//
//  RegisterViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 4.05.2023.
//

import UIKit
import NotificationBannerSwift

class RegisterViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private weak var userService: UserService? {
          return UserService()
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.becomeFirstResponder()
    }
    
    @IBAction func clickedRegisterBtn(_ sender: Any) {
        guard let firstName = firstNameTextField.text,
                !firstName.isEmpty,
                let lastName = lastNameTextField.text,
                !lastName.isEmpty,
                let username = usernameTextField.text,
                !username.isEmpty,
                let email = emailTextField.text,
                !email.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty else {
                let banner = GrowingNotificationBanner(title: "Error", subtitle: "All fields must be filled in.", style: .danger)
                banner.show()
            
                  return
              }
        
        userService?.registerUser(firstName: firstName, lastName: lastName, username: username, email: email, password: password){ result in
            switch result {
            case .success(let user):
                print("User is successfully registered -> USER: \(user)")
                // Perform here the actions to be taken when the user is successfully registered
                let banner = GrowingNotificationBanner(title: "Success", subtitle: "Your account has been successfully created. You can now Log In!", style: .success)
                banner.show()

                self.navigationController?.popViewController(animated: true)

            case .failure(let error):
                print("The user could not be registered. ERROR: \(error.localizedDescription)")
                // Perform here the actions to be taken when the user is not registered
                let banner = GrowingNotificationBanner(title: "Error", subtitle: "\(error.localizedDescription).", style: .danger)
                banner.show()
            }
        }
    }

    
}
