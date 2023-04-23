//
//  IconsModel.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 23.04.2023.
//

import Foundation

struct RickAndMortyModel: Codable {
    let results: [IconsModel]?
}

struct IconsModel: Codable {
    let image: String?
}
