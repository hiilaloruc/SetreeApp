//
//  GoalService.swift
//  SetreeApp
//
//  Created by HilalOruc on 15.05.2023.
//

import Foundation
import Alamofire

public class GoalService {
    
    internal func getGoals( completion: @escaping (Result<[Goal], Error>) -> Void) {
        let url = "\(rootUrl)/getGoals"
        print("Request Url: ", url)
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: GetGoalsResponse<Goal>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded, let goals = response.goals {
                    completion(.success(goals))
                } else {
                    let errorMessage =  "Error occured while getting goals."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
   /* internal func getCollection(collectionId: Int, completion: @escaping (Result<Collection, Error>) -> Void) {
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
    }*/
    
    internal func getGoalDetail(goalId: Int, completion: @escaping (Result<Goal, Error>) -> Void) {
        let url = "\(rootUrl)/getGoalDetail/\(goalId)"
        print("Request Url: ", url)
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: GetGoalDetailResponse<Goal>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeded, let goal = response.goal {
                    completion(.success(goal))
                } else {
                    let errorMessage =  "Error occured while getting goals."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func createMultipleGoalItems(goalItemsArray: [String], goalId: Int ,completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/createMultipleGoalItems"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "itemArray":goalItemsArray,
            "goalId": goalId,

        ], encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: createMultipleGoalItemsResponse<String>.self) { response in
            print("response:", response)
            switch response.result {
                case .success(let response):
                    if response.succeeded {
                        completion(.success(response.message ?? "Succes!"))
                    } else {
                        let errorMessage = "Goal Items couldn't be created."
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    
}
