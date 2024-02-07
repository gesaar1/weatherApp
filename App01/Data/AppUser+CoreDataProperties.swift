//
//  AppUser+CoreDataProperties.swift
//  App01
//
//  Created by Getter Saar on 28.01.2024.
//
//

import Foundation
import CoreData


extension AppUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUser")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var picture: Data?
    @NSManaged public var lastName: String?

}

extension AppUser : Identifiable {

}
