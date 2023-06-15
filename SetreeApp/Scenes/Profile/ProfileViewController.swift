//
//  ProfileViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 24.03.2023.
//

import UIKit
import NotificationBannerSwift
let genders = ["Male", "Female", "Other"]

class ProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var userImageView: UIImageView!
    
    private weak var userService: UserService?{
        return UserService()
    }
    private weak var cloudinaryService: CloudinaryService?{
        return CloudinaryService()
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
            
            if let url = URL(string: user.imageUrl){
                self.userImageView.kf.setImage(with: url)
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
            
            
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutOfKeyboard(_:)))
           view.addGestureRecognizer(tapGesture)
            
            
            
           
        }
    }
    
     @objc func handleTapOutOfKeyboard(_ sender: UITapGestureRecognizer) {
         // hide keybooard
         view.endEditing(true)
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
        
        DispatchQueue.main.async {
            LoadingScreen.show()
        }
        
        userService?.updateUser(firstName: self.firstnameTextField.text ?? "", lastName: self.surnameTextField.text ?? "", username: self.usernameTextField.text ?? "", email: self.emailTextField.text ?? "", gender: gender){ result in
            DispatchQueue.main.async {
                LoadingScreen.hide()
            }
            switch result {
            case .success(let user):
                print("User is successfully updated -> USER: \(user)")
                // Perform here the actions to be taken when the user is successfully updated
                baseUSER = user
                Banner.showSuccessBanner(message:"Your account has been successfully updated.")
                self.navigationController?.popViewController(animated: true)

            case .failure(let error):
                print("The user could not be updated. ERROR: \(error.localizedDescription)")
                // Perform here the actions to be taken when the user is not updated
                Banner.showErrorBanner(with: error)
            }
        }
    }
    
    @IBAction func clickedLogOut(_ sender: Any){
        print("clickedLogOut..")
        let alertVC = UIAlertController(title: "Log out", message: "Are you sure you want to proceed with the logout?", preferredStyle: .alert)

        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            print("Cancelled")
            self.dismiss(animated: false, completion: nil)
        }))
        
        alertVC.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (action) in
            //UserDefaults.standard.removeObject(forKey: "baseTOKEN")
            LocalStorage.removeItem(key: "baseTOKEN")
            Banner.showInfoBanner(message: "You need to login to continue using your account.")
            let vc = UIStoryboard.init(name: "Auth" , bundle: nil).instantiateInitialViewController()!
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }))
        present(alertVC, animated: false, completion: nil)


    }
    
    @IBAction func clickedEditImage(_ sender: Any) {
        print("clickedEditImage..")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true // Kırpma özelliğini etkinleştir
        
        print("imagePicker presenting...")
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            print("imagePicker-> Cropped Image selected..")
            DispatchQueue.main.async {
                LoadingScreen.show()
            }
            cloudinaryService?.uploadImage(image: image) { result in
                DispatchQueue.main.async {
                    LoadingScreen.hide()
                }
                switch result {
                case .success(let uploadResult):
                    // Upload successfull to cloudinary
                    if let publicId = uploadResult.publicId {
                        print("Profile image succesfully loaded. (public ID): \(publicId)")
                        let imageUrl = Environment.getImageRootUrl() + publicId
                        print("imageUrl: ", imageUrl)
                        //SEND UPDATE IMAGE REQUEST TO API
                        self.userService?.updateProfileImage(newUrl: imageUrl){ result in
                            switch result {
                            case .success(let user):
                                print("User is successfully updated -> USER: \(user)")
                                baseUSER = user
                                self.userImageView.image = image
                                
                                Banner.showSuccessBanner(message: "Your profile photo has been successfully updated.")
                            case .failure(let error):
                                print("The user could not be updated. ERROR: \(error.localizedDescription)")
                                // Perform here the actions to be taken when the user is not updated
                                Banner.showErrorBanner(with: error)
                            }
                        }
                    } else {
                        print("Profile image public ID is nil.")
                    }
                case .failure(let error):
                    print("Profil resmi yüklenirken bir hata oluştu: \(error)")
                    // Yükleme başarısız
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("imagePicker canceled..")
    }
    
    
    @IBAction func clickedChangePassword(_ sender: Any){
        print("clickedChangePassword..")
        
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Change Password", message: "", preferredStyle: .alert)

        // Add the text fields to the stack view
        alertController.addTextField { (textField) in
            textField.placeholder = "Old Password"
            textField.isSecureTextEntry = true // Mask applied to the text field
        }

        alertController.addTextField { (textField2) in
            textField2.placeholder = "New Password"
            textField2.isSecureTextEntry = true // Mask applied to the text field
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // Handle cancel action
            alertController.dismiss(animated: true, completion: nil)
        }
        let saveAction = UIAlertAction(title: "Change", style: .default) { _ in

            // this code runs when the user hits the "save" button
            let oldPass = alertController.textFields![0].text
            print("oldPass: ",oldPass)
            
            let newPass = alertController.textFields![1].text
            print("newPass: ",newPass)
            
            if let oldPass = oldPass, !oldPass.isEmpty,
               let newPass = newPass, !newPass.isEmpty,
               oldPass.count > 4, newPass.count > 4 {
                DispatchQueue.main.async {
                    LoadingScreen.show()
                }
                self.userService?.updatePassword(oldPassword: oldPass, newPassword: newPass ){ result in
                    DispatchQueue.main.async {
                        LoadingScreen.hide()
                    }
                    switch result {
                    case .success(let message ):
                        Banner.showSuccessBanner(message:message)
                    case .failure(let error):
                        Banner.showErrorBanner(with: error)
                    }
                }
            }else{
                Banner.showInfoBanner(message: "Password length must be at least 4 characters")
            }

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
        
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
