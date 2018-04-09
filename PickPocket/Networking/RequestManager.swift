//
//  RequestManager.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation
import Intrepid

enum RequestManagerError: Error {
    case http(statusCode: Int)
    case noResponse
    case unknown(message: String?)
}

struct RequestManager {

    func post(guess: String,
              userID: String,
              completion: @escaping ((Result<GuessResult>) -> Void)) {

        let urlRequest = Request.pickLock(guess: guess, userID: userID).urlRequest

        send(urlRequest: urlRequest) { result in
            do {
                let data = try result.extract()
                let response = try JSONDecoder().decode(PickLockResponse.self, from: data)
                completion(response.result)
            } catch let error {
                completion(.failure(error))
            }
        }
    }

    private func send(urlRequest: URLRequest, completion: @escaping (Result<Data>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(RequestManagerError.unknown(message: nil)))
                return
            }

            guard let data = data else {
                completion(.failure(RequestManagerError.noResponse))
                return
            }

            let statusCode = httpResponse.statusCode
            switch statusCode {
            case 200..<300:
                completion(.success(data))
            default:
                let error = RequestManagerError.http(statusCode: statusCode)
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
}
