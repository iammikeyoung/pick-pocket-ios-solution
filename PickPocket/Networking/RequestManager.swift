//
//  RequestManager.swift
//  PickPocket
//
//  Created by Maya Saxena on 9/14/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation
import Intrepid

enum RequestManagerError: Error {
    case requestCreation
    case decoding
    case http(statusCode: Int)
    case noResponse
    case unknown(message: String?)
}

struct RequestManager {
    private var token: String {
        return "1e32c098-93cf-11e7-8bf1-e29045b92989"
    }

    func post(guess: String,
              userID: String,
              completion: @escaping ((Result<GuessResult>) -> Void)) {

        guard let urlRequest = createPostRequest(userID: userID, guess: guess) else {
            completion(.failure(RequestManagerError.requestCreation))
            return
        }

        send(urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                if let response = try? JSONDecoder().decode(PickLockResponse.self, from: data) {
                    completion(.success(response.result))
                } else {
                    completion(.failure(RequestManagerError.decoding))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createPostRequest(userID: String, guess: String) -> URLRequest? {
        let urlString = "https://5gbad1ceal.execute-api.us-east-1.amazonaws.com/release/picklock/\(userID)"

        guard let url = URL(string: urlString) else { return nil }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = PickLockBody(token: token, guess: guess)
        guard let httpBody = try? JSONEncoder().encode(body) else { return nil }

        urlRequest.httpBody = httpBody

        return urlRequest
    }

    private func send(urlRequest: URLRequest, completion: @escaping (Result<Data>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                completion(.failure(error))
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
        })

        dataTask.resume()
    }
}
