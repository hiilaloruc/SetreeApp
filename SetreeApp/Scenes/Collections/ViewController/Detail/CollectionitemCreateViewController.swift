//
//  CollectionitemCreateViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 30.05.2023.
//

import UIKit

enum CollectionItemType: String {
    case title
    case text
    case image
}

class CollectionitemCreateViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    internal var itemType: CollectionItemType = .title{
        didSet{
            if titleBtn != nil {
                updateUI()
            }
        }
    }
    
    private weak var cloudinaryService : CloudinaryService? {
        return CloudinaryService()
    }
    
    private weak var collectionService : CollectionService? {
        return CollectionService()
    }
    
    
    
    @IBOutlet weak var titleBtn: UIButton!
    @IBOutlet weak var textBtn: UIButton!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var selectLibraryBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    internal var createTextOrTitle: ((String, String) -> Void)?
    internal var createImage: ((String) -> Void)?

    

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        updateUI()
        let createButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(createButtonTapped))
        navigationItem.rightBarButtonItem = createButton
        
    }
    
    @objc func createButtonTapped() {
        print("Create button tapped request is sending to api...")
        
        switch itemType {
        case .title, .text:
            guard let content = textView.text, !content.isEmpty else {
                   Banner.showInfoBanner(message: "Content cannot be empty.")
                   return
            }

            self.createTextOrTitle?(self.itemType.rawValue, content)
            self.dismiss(animated: true)
            
        case .image:
            if let image = imageView.image {
                uploadImageToCloudinary(image: image)
                self.dismiss(animated: true)
                
            }else {
                Banner.showInfoBanner(message: "Image is required.")
            }
        }
        
        
       
        
        
    }
    
     func uploadImageToCloudinary(image: UIImage){
         print("upload image to cloudinary image: ",image)
         self.cloudinaryService?.uploadProfileImage(image: image) { result in
            switch result {
            case .success(let uploadResult):
                // Upload successfull to cloudinary
                if let publicId = uploadResult.publicId {
                    print("image succesfully loaded. (public ID): \(publicId)")
                    let imageUrl = Environment.getImageRootUrl() + publicId
                    //imageUrl ready.
                    self.createTextOrTitle?(self.itemType.rawValue, imageUrl)
                } else {
                    print("Response image's public ID is nil.")
                }
            case .failure(let error):
                Banner.showErrorBanner(with: error)
            }
        }
    }
    
    
    func prepareForReuse(){
        self.titleBtn.backgroundColor = .systemGray6
        self.titleBtn.tintColor = UIColor.mainRoyalBlueColor
        self.textBtn.backgroundColor = .systemGray6
        self.textBtn.tintColor = UIColor.mainRoyalBlueColor
        self.imageBtn.backgroundColor = .systemGray6
        self.imageBtn.tintColor = UIColor.mainRoyalBlueColor
        self.lineView.isHidden = false
        self.textView.isHidden = false
        self.selectLibraryBtn.isHidden = true
        self.imageView.isHidden = true
    }
    
    func updateUI(){
        prepareForReuse()
        switch itemType {
        case .title:
            self.infoLabel.text = "Adding Title"
            self.titleBtn.backgroundColor = UIColor.mainRoyalBlueColor
            self.titleBtn.tintColor = .systemGray6
        case .text:
            self.infoLabel.text = "Adding Text"
            self.textBtn.backgroundColor = UIColor.mainRoyalBlueColor
            self.textBtn.tintColor = .systemGray6
        case .image:
            self.infoLabel.text = "Adding Image"
            self.lineView.isHidden = true
            self.textView.isHidden = true
            self.selectLibraryBtn.isHidden = false
            self.imageView.isHidden = false
            self.imageBtn.backgroundColor = UIColor.mainRoyalBlueColor
            self.imageBtn.tintColor = .systemGray6
        }
    }
    
    func updateTextViewHeight() {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textViewHeightConstraint.constant = newSize.height // Yükseklik constraint'ini güncelleyin
    }
    
    @IBAction func selectLibraryBtn(_ sender: Any) {
        print("Select from Library clicked..")
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
    

    @IBAction func addTitleClicked(_ sender: Any) {
        setItemType(.title)
    }

    @IBAction func addTextClicked(_ sender: Any) {
        setItemType(.text)
    }

    @IBAction func addImageClicked(_ sender: Any) {
        setItemType(.image)
    }

    private func setItemType(_ itemType: CollectionItemType) { //if already in that type, no need for the change.
        if self.itemType != itemType {
            self.itemType = itemType
        }
    }
    

    


}
extension CollectionitemCreateViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
      }
    
}
