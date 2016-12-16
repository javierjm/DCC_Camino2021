//
//  Person+CoreDataClass.swift
//  Figueres2018
//
//  Created by Javier Jara on 12/7/16.
//  Copyright © 2016 Data Center Consultores. All rights reserved.
//

import Foundation
import CoreData


public class Person: NSManagedObject {
    func toPersonModel()->PersonModel {
        return PersonModel( codelec:codelec,id:id, junta:junta, sexo:sexo, apellido1:apellido1, apellido2:apellido2, nombre:nombre, fechacaduc:fechacaduc)
    }

    
}
