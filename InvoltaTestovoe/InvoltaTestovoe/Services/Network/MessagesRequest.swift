//
//  MessagesRequest.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import Foundation

final class MessageRequest {

    // MARK: - Constants

    private enum Constants {
        static let domain = "https://numia.ru/api/"
        static let methods = "getMessages"
        static let offSet = "offset"
    }

    // MARK: - Methods

    func getMessages(offSet: String, completion: @escaping RequestBlock<String>) {
        let stringUrl = "\(Constants.domain)" + "\(Constants.methods)" + "?" + "\(Constants.offSet)" + "=" + "\(offSet)"
        guard let url = URL(string: stringUrl) else { return }
        
        let params = URLSessionConfiguration.default
        params.httpMaximumConnectionsPerHost = 7
        params.timeoutIntervalForResource = 5
        params.timeoutIntervalForRequest = 5
        params.requestCachePolicy = .reloadIgnoringCacheData
        
        URLSession(configuration: params).dataTask(with: url) { (data, _, error) in
            if let data = data {
                do {
                    let returnData = try JSONDecoder().decode(MessagesRequestModel.self, from: data)
                    let stringsResult = returnData.result

                    completion(.success(Array(stringsResult ?? [])))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

}
