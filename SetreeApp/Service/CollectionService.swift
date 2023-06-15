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
                if response.succeded, let collection = response.collection {
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
    
    internal func getItemsByCollection(collectionId: Int, completion: @escaping (Result<[CollectionItem], Error>) -> Void) {
        let url = "\(rootUrl)/getItemsByCollection/\(collectionId)"
        print("Request Url: ", url)
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: getItemsByCollectionResponse<CollectionItem>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded, let collectionItems = response.collectionItems  {
                    completion(.success(collectionItems))
                } else {
                    let errorMessage =  "Error occured while getting collection items."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func deleteCollection(collectionId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/deleteCollection"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "status":"inactive",
            "id":collectionId

        ], encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: baseAnswerWithMessage<String>.self) { response in
            print("response:", response)
            switch response.result {
                case .success(let response):
                    if response.succeded {
                        completion(.success(response.message ?? "Succes!"))
                    } else {
                        let errorMessage = "Goal couldn't be deleted."
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    internal func deleteCollectionItem( collectionItemId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/deleteCollectionItem/\(collectionItemId)"
        print("Request Url: ", url)
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: baseAnswerWithMessage<String>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeded, let message = response.message {
                    completion(.success(message))
                } else {
                    let errorMessage =  "Error occured while deleting collection item."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func createCollectionItem(content: String, type: String ,collectionId: Int ,completion: @escaping (Result<CollectionItem, Error>) -> Void) {
        let url = "\(rootUrl)/createCollectionItem"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "content":content,
            "type":type,
            "collectionId": collectionId,

        ], encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: CreateCollectionItemResponse<CollectionItem>.self) { response in
            print("response:", response)
            switch response.result {
                case .success(let response):
                if response.succeded, let collectionItem = response.collectionItem {
                        completion(.success(collectionItem))
                    } else {
                        let errorMessage = "Collection Item couldn't be created."
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    internal func getCollectionsByTag(tag: String, completion: @escaping (Result<[Collection], Error>) -> Void) {
        let url = "\(rootUrl)/getCollectionsByTag/\(tag)"
        print("Request Url: ", url)
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: GetCollectionsByTagResponse<Collection>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.success, let collections = response.collections {
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
    
    internal func getLikedCollections(userid: Int, completion: @escaping (Result<[Collection], Error>) -> Void) {
        let url = "\(rootUrl)/getLikedCollections/\(userid)"
        print("Request Url: ", url)
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: GetCollectionsByTagResponse<Collection>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.success, let collections = response.collections {
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
    
    internal func likeCollection(collectionId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/likeACollection/\(collectionId)"
        
        // Alamofire : POST request
        AF.request(url, headers: headers()).responseDecodable(of: BaseResponseW_2E<String>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded , let message = response.message {
                    completion(.success(message))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message ?? "Collection couldn't be liked."])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func dislikeCollection(collectionId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/dislikeACollection/\(collectionId)"
        
        // Alamofire : POST request
        AF.request(url, headers: headers()).responseDecodable(of: BaseResponseW_2E<String>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded , let message = response.message {
                    completion(.success(message))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message ?? "Collection couldn't be liked."])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
}
