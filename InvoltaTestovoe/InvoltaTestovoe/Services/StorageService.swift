//
//  StorageService.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 21.04.2023.
//

import Foundation

final class StorageService {

    // MARK: - Properties

    static let shared = StorageService()

    // MARK: - Keys

    enum Keys: String {
        case messages = "LocalMessages"
    }

    // MARK: - Initialization

    private init() { }

    // MARK: - Methods

    func save<T: Sequence>(value: [T], key: Keys) {
        UserDefaults().set(value, forKey: key.rawValue)
    }

    func load(key: Keys) -> [String] {
        return UserDefaults.standard.array(forKey: key.rawValue) as? [String] ?? []
    }

    func delete(for key: Keys,at index: Int) {
        var items = load(key: key)
        items.remove(at: index)
        UserDefaults().removeObject(forKey: key.rawValue)
        UserDefaults().set(items, forKey: key.rawValue)
    }

}
