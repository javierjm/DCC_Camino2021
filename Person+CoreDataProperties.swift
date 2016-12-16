//
//  Person+CoreDataProperties.swift
//  Figueres2018
//
//  Created by Javier Jara on 12/7/16.
//  Copyright © 2016 Data Center Consultores. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var codelec: Int32
    @NSManaged public var id: Int32
    @NSManaged public var junta: Int32
    @NSManaged public var sexo: Int32
    @NSManaged public var apellido1: String?
    @NSManaged public var apellido2: String?
    @NSManaged public var nombre: String?
    @NSManaged public var fechacaduc: Date?

}
