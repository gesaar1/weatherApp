//
//  WeatherInfo+CoreDataProperties.swift
//  App01
//
//  Created by Getter Saar on 29.01.2024.
//
//

import Foundation
import CoreData


extension WeatherInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherInfo> {
        return NSFetchRequest<WeatherInfo>(entityName: "WeatherInfo")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var location: String?
    @NSManaged public var temp: Double
    @NSManaged public var userID: UUID?

}

extension WeatherInfo : Identifiable {

}
