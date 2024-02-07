//
//  DataController.swift
//  App01
//
//  Created by Getter Saar on 28.01.2024.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("Data saved")
        } catch{
            print("Failed to save data")
        }
    }
    
    
    func createItem(location: String, temp: Double, userId: UUID ,context: NSManagedObjectContext){
        let newItem = WeatherInfo(context: context)
        newItem.id = UUID()
        newItem.date = Date()
        newItem.location = location
        newItem.temp = temp
        newItem.userID = userId
        save(context: context)
    }
    
    func createItem(location: String, temp: Double, context: NSManagedObjectContext){
        let newItem = WeatherInfo(context: context)
        newItem.id = UUID()
        newItem.date = Date()
        newItem.location = location
        newItem.temp = temp
        save(context: context)
    }
    
    
    
    func getWeatherInfo(context: NSManagedObjectContext) -> [WeatherInfo]{
        var models = [WeatherInfo]()
                do {
                    models = try context.fetch(WeatherInfo.fetchRequest())

                } catch {
                    // Handle error
                    print("Error fetching data: \(error)")
                }
        return models
    }
    
    
    func deleteItem(item: WeatherInfo, context: NSManagedObjectContext){
        context.delete(item)
        save(context: context)
    }
    
    
}

