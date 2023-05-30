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
    
    internal func createGoal(title: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/createGoal"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "title":title

        ], encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: baseAnswerWithMessage<String>.self) { response in
            print("response:", response)
            switch response.result {
                case .success(let response):
                    if response.succeded {
                        completion(.success(response.message ?? "Succes!"))
                    } else {
                        let errorMessage = "Goal couldn't be created."
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    internal func deleteGoal(goalId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/deleteGoal"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "status":"inactive",
            "id":goalId

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

        ], encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: BaseResponseW_2E<String>.self) { response in
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
    
    internal func deleteGoalItem( goalItemId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/deleteGoalItem/\(goalItemId)"
        print("Request Url: ", url)
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: baseAnswerWithMessage<String>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeded, let message = response.message {
                    completion(.success(message))
                } else {
                    let errorMessage =  "Error occured while deleting goals."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    internal func updateGoalItem(goalItemId: Int,goalItemContent: String,goalItemIsDone:Bool ,completion: @escaping (Result<GoalItem, Error>) -> Void) {
        let url = "\(rootUrl)/updateGoalItem"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "content": goalItemContent,
            "isDone": goalItemIsDone,
            "id": goalItemId
        ], encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: updateGoalItemResponse<GoalItem>.self) { response in
            print("response:", response)
            switch response.result {
                case .success(let response):
                if response.succeded, let goalItem = response.goalItem {
                        completion(.success(goalItem))
                    } else {
                        let errorMessage = "Goal couldn't be updated."
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    
}
