import Foundation

struct PersonModel : Equatable {
    
    var codelec: Int32
    var id: Int32
    var junta: Int32
    var sexo: Int32
    var apellido1: String?
    var apellido2: String?
    var nombre: String?
    var fechacaduc: Date?
}

func ==(lhs: PersonModel, rhs: PersonModel) -> Bool {
    var dateEqual = false
    if let lhsDate = lhs.fechacaduc, let rhsDate = rhs.fechacaduc {
        dateEqual = lhsDate.timeIntervalSince(rhsDate as Date) < 1.0
    }
    
    return lhs.id == rhs.id
        && lhs.codelec == rhs.codelec
        && lhs.junta == rhs.junta
        && lhs.sexo == rhs.sexo
        && lhs.apellido1 == rhs.apellido1
        && lhs.apellido2 == rhs.apellido2
        && lhs.nombre == rhs.nombre
        && dateEqual
}

