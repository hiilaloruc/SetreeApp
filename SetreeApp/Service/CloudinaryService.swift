//
//  CloudinaryService.swift
//  SetreeApp
//
//  Created by HilalOruc on 24.05.2023.
//

import Foundation
import Cloudinary


public class CloudinaryService {
    
    func uploadProfileImage(image: UIImage, folderName: String = "Setree", completion: @escaping (Result<CLDUploadResult, Error>) -> Void) {
        if let cloudinary = Environment.getCloudinary() {
            let preset = Environment.getCloudinaryPreset()
            let params = CLDUploadRequestParams()
            params.setFolder(folderName) // Resmi belirli bir klasöre yüklemek için kullanılacak
            
            // Profil resmini yükle
            cloudinary.createUploader().upload(data: image.pngData()!, uploadPreset: preset, params: params) { (result, error) in
                if let error = error {
                    print("Cloudinary gave error ..")
                    completion(.failure(error))
                } else if let result = result {
                    print("Cloudinary successfully loaded result: ", result)
                    completion(.success(result))
                }
            }
        }
    }


    
    
}
