//
//  UserListRequestManager.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/17/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct UserListRequestManager {

    private let baseURL = "https://5gbad1ceal.execute-api.us-east-1.amazonaws.com/release"

    func getUsers(completion: @escaping ([RemoteUser]) -> Void) {
        let endpoint = "/users"
        let url = URL(string: "\(baseURL)\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        send(urlRequest: request) { data in
            guard let data = data else {
                completion([])
                return
            }

            let response = try? JSONDecoder().decode(UserListResponse.self, from: data)
            completion(response?.result ?? [])
        }
    }

    private func send(urlRequest: URLRequest, completion: @escaping (Data?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            switch httpResponse.statusCode {
            case 200..<300:
                completion(data)
            default:
                completion(nil)
            }
        })

        dataTask.resume()
    }
}

private struct UserListResponse: Codable {
    let result: [RemoteUser]
}
