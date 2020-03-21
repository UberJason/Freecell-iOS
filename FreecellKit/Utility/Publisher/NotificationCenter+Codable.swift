//
//  NotificationCenter+Codable.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/21/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Combine
import Foundation

public extension NotificationCenter {
    func post<T: Codable>(_ name: Notification.Name, value: T) throws {
        let data = try JSONEncoder().encode(value)
        post(name: name, object: nil, userInfo: ["data": data])
    }
}

public extension NotificationCenter.Publisher {
    func decode<Item: Decodable>(to: Item.Type) -> AnyPublisher<Item, Error> {
        return self
            .compactMap { $0.userInfo?["data"] as? Data }
            .decode(type: Item.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
