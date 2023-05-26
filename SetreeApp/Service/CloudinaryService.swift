//
//  CloudinaryService.swift
//  SetreeApp
//
//  Created by HilalOruc on 24.05.2023.
//

import Foundation
import Cloudinary
import Alamofire


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
    
    func getImageByTitle(title: String = "architecture", completion: @escaping (Result<ImageResponse, Error>) -> Void){
        let url = "https://pixabay.com/api/?key=\(Environment.getPixabayKey())&q=\(title)&image_type=photo&pretty=true&per_page=3"
        AF.request(url).responseDecodable(of: ImageResponse.self) { response in
            switch response.result {
            case .success(let imageResponse):
                completion(.success(imageResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    
}
