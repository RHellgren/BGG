//
//  BGGAPI.swift
//  BGG
//
//  Created by Robin Hellgren on 27/08/2020.
//  Copyright © 2020 Robin Hellgren. All rights reserved.
//

import Foundation
import Alamofire

public final class BGGAPI {
    
    private let baseURL = "https://www.boardgamegeek.com/xmlapi2"

    public init() { }

    public func getHotItems(type: ItemType, completion: @escaping ((HotItems?) -> Void)) {
        let path = "/hot"
        let parameters: [String: Any] = [
            "type": type.rawValue
        ]

        perform(path: path, parameters: parameters) { response in

            switch response.result {
            case .success(let data):
                HotItemsParser().parse(data: data) { items in
                    completion(items)
                }

            case .failure(let error):
                completion(nil)
                print(error)
            }
        }
    }

    public func getItem(id: String, type: ThingType, completion: @escaping ((Thing?) -> Void)) {
        let path = "/thing"
        let parameters: [String: Any] = [
            "id": id,
            "type": type.rawValue,
            "versions": "1",
            "videos": "1",
            "stats": "1",
            "historical": "1",
            "marketplace": "1",
            "comments": "1",
            "ratingcomments": "1",
            "page": 1,
            "pagesize": 100
        ]

        perform(path: path, parameters: parameters) { response in
            switch response.result {
            case .success(let data):
                ThingParser().parse(data: data) { thing in
                    completion(thing)
                }
            case .failure(let error):
                completion(nil)
                print(error)
            }
        }
    }


    private func perform(path: String,
                         parameters: [String: Any],
                         completion: @escaping ((DataResponse<Data, AFError>) -> Void)) {

        AF.request(baseURL + path, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["text/xml"])
            .responseData { response in
                completion(response)
            }
    }
}
