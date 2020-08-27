//
//  DataService.swift
//  BGG
//
//  Created by Robin Hellgren on 27/08/2020.
//  Copyright © 2020 Robin Hellgren. All rights reserved.
//

import Foundation
import BGGAPI

final class DataService {
    private let api = BGGAPI()

    func test() {
        api.getHotItems(type: .boardgame) { hotItems in
            guard let hotItems = hotItems else {
                print("Error fetching hotItems")
                return
            }

            print(hotItems)

            let id = hotItems.items.first!.id
            self.api.getItem(id: id, type: .boardgame) { thing in
                guard let thing = thing else {
                    print("Error fetching thing with id: \(id)")
                    return
                }

                print(thing)
            }
        }


    }
}
