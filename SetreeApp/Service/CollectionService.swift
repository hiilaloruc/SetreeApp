//
//  CollectionService.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.05.2023.
//

import Foundation
import Alamofire

public class CollectionService {
    
    internal func createCollection(title: String, tagReq:String?,isPublic: Bool = true, imageUrl:String, completion: @escaping (Result<Collection, Error>) -> Void) {
        let url = "\(rootUrl)/createCollection"

        var parameters: [String: Any] = [
            "title": title,
            "isPublic": isPublic,
            "imageUrl": imageUrl
        ]

        if let tag = tagReq {
            parameters["tagReq"] = tag.replacingOccurrences(of: " ", with: "")
        }
        
        // Alamofire : POST request
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: CreateCollectionResponse<Collection>.self) { response in
            print("response:", response)
            switch response.result {
                case .success(let response):
                if response.succeded , let collection = response.collection{
                        completion(.success(collection))
                    } else {
                        let errorMessage = "Collection couldn't be created."
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    
    internal func getCollections(userId: Int, completion: @escaping (Result<[Collection], Error>) -> Void) {
        let url = "\(rootUrl)/getCollections/\(userId)"
        print("Request Url: ", url)
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: GetCollectionsResponse<Collection>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded, let collections = response.collections {
                    completion(.success(collections))
                } else {
                    let errorMessage =  "Error occured while getting collections."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func getCollection(collectionId: Int, completion: @escaping (Result<Collection, Error>) -> Void) {
        let url = "\(rootUrl)/getCollection/\(collectionId)"
        print("Request Url: ", url)
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: GetCollectionResponse<Collection>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded, let collection = response.collection {
                    completion(.success(collection))
                } else {
                    let errorMessage =  "Error occured while getting collections."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func getCollectionDetail(collectionId: Int, completion: @escaping (Result<Collection, Error>) -> Void) {
        let url = "\(rootUrl)/getCollectionDetail/\(collectionId)"
        print("Request Url: ", url)
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: getCollectionDetailResponse<Collection>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded, let collections = response.collections {
                    completion(.success(collections))
                } else {
                    let errorMessage =  "Error occured while getting collections."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
