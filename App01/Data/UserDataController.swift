//
//  UserDataController.swift
//  App01
//
//  Created by Getter Saar on 29.01.2024.
//

import Foundation
import CoreData
import UIKit

class UserDataController: ObservableObject{
    
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("Data saved")
        } catch{
            print("Failed to save data")
        }
    }
    
    //Need context to make sure that we are handling the same database
    func saveUserInfo(name: String, image: UIImage, context: NSManagedObjectContext){
        let imageData = image.pngData()
        let user = AppUser(context: context)
        user.id = UUID()
        user.name = name
        user.picture = imageData
       // weather.date = Date()
       // weather.location = loaction
       // weather.temp = temp
        save(context: context)
    }
    
    

        func getUserById(id: UUID, context: NSManagedObjectContext) -> AppUser? {
            let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let users = try context.fetch(request)
                return users.first
            } catch {
                print("Error fetching user by ID: \(error.localizedDescription)")
                return nil
            }
        }
    
    func getAllUsers(context: NSManagedObjectContext) -> [AppUser]{
        var models = [AppUser]()
                do {
                    models = try context.fetch(AppUser.fetchRequest())

                } catch {
                    // Handle error
                    print("Error fetching data: \(error)")
                }
        return models
    }
    
    func deleteUser(item: AppUser, context: NSManagedObjectContext){
        context.delete(item)
        save(context: context)
    }

}

