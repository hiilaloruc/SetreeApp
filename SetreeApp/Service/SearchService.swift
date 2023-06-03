//
//  SearchService.swift
//  SetreeApp
//
//  Created by HilalOruc on 3.06.2023.
//

import Foundation
import Alamofire

public class SearchService {
    
    internal func search(keyword: String, completion: @escaping (Result<SearchResponse<String>, Error>) -> Void) {
        let url = "\(rootUrl)/search"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "keyword":keyword

        ], encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: SearchResponse<String>.self) { response in
            print("response:", response)
            switch response.result {
                case .success(let searchResponse):
                    if searchResponse.succeeded {
                        completion(.success(searchResponse))
                    } else {
                        let errorMessage = "Error occured while trying to search"
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
