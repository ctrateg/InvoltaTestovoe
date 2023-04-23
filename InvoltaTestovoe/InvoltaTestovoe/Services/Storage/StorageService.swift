//
//  StorageService.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 21.04.2023.
//

import CoreData

final class StorageService {

    // MARK: - Constants
    
    private enum Constants {
        static let messageModelName = "MessageStorageModel"
    }

    // MARK: - Properties

    static let shared = StorageService()

    // MARK: - Private Properties

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.messageModelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private lazy var managedContext = self.persistentContainer.viewContext

    // MARK: - Initialization

    private init() { }

    // MARK: - Methods

    func save(value: String) {
        let entity = MessageStorageModel(context: persistentContainer.viewContext)
        entity.message = value
        do {
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("Ошибка при сохранении: \(error), \(error.userInfo)")
        }
//        UserDefaults().set(values, forKey: key.rawValue)
    }

    func load() -> [MessageStorageModel] {
        let request = NSFetchRequest<MessageStorageModel>(entityName: Constants.messageModelName)

        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch let error as NSError {
          print("Ошибка при загрузке данных: \(error), \(error.userInfo)")
            return []
        }
    }

    func remove(model: MessageStorageModel) {
        do {
            persistentContainer.viewContext.delete(model)
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("Ошибка при удалении: \(error), \(error.userInfo)")
        }
    }

    func saveContext() {
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          context.rollback()
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }

}
