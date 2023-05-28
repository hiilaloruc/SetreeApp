//
//  CollectionCreateViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 26.05.2023.
//

import UIKit
import NotificationBannerSwift

class CollectionCreateViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var tagTF: UITextField!
    @IBOutlet weak var isPublicSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    internal var senderVC: UIViewController?

    
    private weak var cloudinaryService : CloudinaryService? {
        return CloudinaryService()
    }
    
    private weak var collectionService : CollectionService? {
        return CollectionService()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTF.becomeFirstResponder()
        titleTF.delegate = self
        tagTF.delegate = self
        
        let createButton = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createButtonTapped))
        navigationItem.rightBarButtonItem = createButton
        
    }
    
    @objc func createButtonTapped() {
        print("Create button tapped request is sending to api...")
        
        guard let title = titleTF.text, !title.isEmpty else {
               Banner.showInfoBanner(message: "Title is required.")
               return
        }
        
        if let image = imageView.image {
            uploadImageToCloudinary(image: image)
        }else {
            Banner.showInfoBanner(message: "Image is required.")
        }
    }
    
    func createCollection(imageUrl:String){
        guard let title = titleTF.text, !title.isEmpty else {
                Banner.showInfoBanner(message: "Title is required.")
                return
            }
        var tag: String?
        
        if let tagText = tagTF.text, tagText.count > 1 {
            tag = tagText
        }
        
        let isPublic = isPublicSwitch.isOn
        print("title: ", title,", tagReq: ",tag ,", isPublic: ", isPublic)
        self.collectionService?.createCollection(title: title, tagReq: tag , isPublic: isPublic, imageUrl: imageUrl) { result in
            switch result {
            case .success(let collection):
                Banner.showSuccessBanner(message: "Collection created!")
                print("Collection created id: ", collection.collectionId)
                if let firstVC = self.senderVC as? CollectionsViewController {
                    firstVC.initUI()
                    // Scroll to the last item in the last section
                    let itemCount = firstVC.collectionsView.numberOfItems(inSection: 0)
                    firstVC.collectionsView.scrollToItem(at: IndexPath(item: itemCount - 1, section: 0), at: .bottom, animated: true)
                    
                }
                
                self.dismiss(animated: true)
            case .failure(let error):
                Banner.showErrorBanner(with: error)
            }
            
        }
    }
    
     func uploadImageToCloudinary(image: UIImage){
         self.cloudinaryService?.uploadProfileImage(image: image) { result in
            switch result {
            case .success(let uploadResult):
                // Upload successfull to cloudinary
                if let publicId = uploadResult.publicId {
                    print("Profile image succesfully loaded. (public ID): \(publicId)")
                    let imageUrl = Environment.getImageRootUrl() + publicId
                    //imageUrl ready.
                    self.createCollection(imageUrl: imageUrl)
                } else {
                    print("Response image's public ID is nil.")
                }
            case .failure(let error):
                Banner.showErrorBanner(with: error)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    
    @IBAction func selectPhotoClicked(_ sender: Any) {
        print("selectPhotoClicked")
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
            self.imageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickForMeClicked(_ sender: Any) {
        print("pickForMeClicked")
        if titleTF.text!.count > 2 {
            print("image title: ",titleTF.text!)
            cloudinaryService?.getImageByTitle(title: titleTF.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )  { result in
                switch result {
                case .success(let imageResponse):
                    //print("selecetedImage url:", imageResponse.hits[0].webformatURL)
                    if imageResponse.hits.count > 0 {
                            print("Webformat URL: \(imageResponse.hits[0].webformatURL)")
                            if let url = URL(string: imageResponse.hits[0].webformatURL){
                                self.imageView.kf.setImage(with: url)
                            }
                    }else{
                        let banner = GrowingNotificationBanner(title: "Sorry!", subtitle: "Please enter different collection title and try again..", style: .info)
                        banner.show()
                    }
                    
                case .failure(let error):
                    Banner.showErrorBanner(with: error)
                }
            }
        }else{
            let banner = GrowingNotificationBanner(title: "Sorry!", subtitle: "Please enter longer collection title and try again..", style: .info)
            banner.show()
        }
          
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            // Switch is turned on
            print("Switch is turned on")
        } else {
            // Switch is turned off
            print("Switch is turned off")
        }
    }

    


}
