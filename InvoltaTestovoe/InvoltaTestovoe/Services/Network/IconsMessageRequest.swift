//
//  IconsMessageRequest.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 23.04.2023.
//

import Foundation

import UIKit

final class IconsMessageRequest {

    // MARK: - Constants

    private enum Constants {
        static let domain = "https://rickandmortyapi.com/api/"
        static let type = "character/"
        static let page = "page"
    }

    // MARK: - Methods

    func getIcon(page: String, completion: @escaping RequestBlock<String>) {
        let stringUrl = "\(Constants.domain)" + "\(Constants.type)" + "?" + "\(Constants.page)" + "=" + "\(page)"
        guard let url = URL(string: stringUrl) else { return }
        
        let params = URLSessionConfiguration.default
        params.httpMaximumConnectionsPerHost = 7
        params.timeoutIntervalForResource = 5
        params.timeoutIntervalForRequest = 5
        params.requestCachePolicy = .reloadIgnoringCacheData
        
        URLSession(configuration: params).dataTask(with: url) { (data, _, error) in
            if let data = data {
                do {
                    let returnData = try JSONDecoder().decode(RickAndMortyModel.self, from: data)
                    let stringsResult = returnData.results?.compactMap { $0.image }
            
                    completion(.success(Array(stringsResult ?? [])))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

}
