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

    // MARK: - Private Properties

    private let jsonDecoder: JSONDecoder

    // MARK: - Initialization

    init() {
        self.jsonDecoder = JSONDecoder()
    }

    // MARK: - Methods

    func getMessages(offSet: String, completion: @escaping ModelBlock<MessagesRequestModel>) {
        let stringUrl = "\(Constants.domain)" + "\(Constants.methods)" + "?" + "\(Constants.offSet)" + "=" + "\(offSet)"
        guard let url = URL(string: stringUrl) else { return }
    
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                do {
                    let returnData = try self.jsonDecoder.decode(MessagesRequestModel.self, from: data)
            
                    completion(returnData)
                } catch let error as NSError {
                    print("\(error), \(error.userInfo)")
                    completion(MessagesRequestModel(result: []))
                }
            }

        }
    
        task.resume()
    }

}
