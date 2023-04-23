//
//  IconMessageRequest.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 23.04.2023.
//

import Foundation

import Foundation

final class IconMessageRequest {

    // MARK: - Constants

    private enum Constants {
        static let domain = "https://numia.ru/api/"
        static let methods = "getMessages"
        static let offSet = "offset"
    }

    // MARK: - Methods

    func getIcon(offSet: String, completion: @escaping RequestBlock<String>) {
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
            
                    DispatchQueue.main.async {
                        completion(.success(Array(stringsResult ?? [])))
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }

}
