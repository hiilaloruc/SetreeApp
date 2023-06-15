//
//  LoginViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 9.05.2023.
//

import UIKit
import NotificationBannerSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private weak var userService: UserService? {
          return UserService()
      }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
    }
    
    
    @IBAction func clickedLoginBtn(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !password.isEmpty,
              !password.isEmpty else {
            
                let banner = GrowingNotificationBanner(title: "Error", subtitle: "Email or password cannot be empty.", style: .danger)
                banner.show()
                return
              }
        DispatchQueue.main.async {
            LoadingScreen.show()
        }
        userService?.loginUser(email: email, password: password){ result in
            DispatchQueue.main.async {
                LoadingScreen.hide()
            }
            switch result {
            case .success(let user):
                print("User is successfully logged in -> USER: \(user)")
                // Perform here the actions to be taken when the user is successfully registered
                baseUSER = user
                
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
                Banner.showSuccessBanner(message: "You successfully logged in.")
                 
            case .failure(let error):
                print("The user could not logged in. ERROR: \(error.localizedDescription)")
                // Perform here the actions to be taken when the user is not registered
                Banner.showErrorBanner(with: error)
            }
        }
    }

}
