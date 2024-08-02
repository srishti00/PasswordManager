//
//  PasswordEntity+CoreDataProperties.swift
//  PasswordManager
//
//  Created by srisshar on 01/08/24.
//
//

import Foundation
import CoreData


extension PasswordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PasswordEntity> {
        return NSFetchRequest<PasswordEntity>(entityName: "PasswordEntity")
    }

    @NSManaged public var accountType: String?
    @NSManaged public var username: String?
    @NSManaged public var password: Data?

}

extension PasswordEntity : Identifiable {

}
