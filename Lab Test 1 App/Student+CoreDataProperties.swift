//
//  Student+CoreDataProperties.swift
//  Lab Test 1 App
//
//  Created by Omairys Uzcátegui on 2021-09-17.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var age: Int32
    @NSManaged public var name: String?
    @NSManaged public var termStart: Date?
    @NSManaged public var tution: Double

}

extension Student : Identifiable {

}
