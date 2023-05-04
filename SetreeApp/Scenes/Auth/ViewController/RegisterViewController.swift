//
//  RegisterViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 4.05.2023.
//

import UIKit

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
        
        
    }
    
    @IBAction func clickedRegisterBtn(_ sender: Any) {
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else {
                  // Gerekli tüm alanları doldurmadan devam edemezsiniz.
                  return
              }
        
        userService?.registerUser(firstName: firstName, lastName: lastName, username: username, email: email, password: password)
    }

    
}
