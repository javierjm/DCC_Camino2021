import Foundation

class LoginWorker
{
  // MARK: - Business Logic
    var loginStore: PersonStoreProtocol
    
    init(loginStore: PersonStoreProtocol)
    {
        self.loginStore = loginStore
    }
    
    func fetchUser(_ id: String, _ completionHandler: @escaping PersonStoreFetchPersonCompletionHandler)
    {
        loginStore.fetchPerson(id) { (result: PersonStoreResult<PersonModel>) in
            completionHandler(result)
        }
    }
}

// MARK: - Orders store API

protocol PersonStoreProtocol{
    // MARK: CRUD operations - Optional error
    func fetchPerson(_ id: String, completionHandler: @escaping(_ user: PersonModel?, _ error: PersonStoreError?) -> Void)
    
    // MARK: CRUD operations - Generic enum result type
    func fetchPerson(_ id: String, completionHandler:  @escaping PersonStoreFetchPersonCompletionHandler)
    
    // MARK: CRUD operations - Inner closure
    func fetchPerson(_ id: String, completionHandler: @escaping(_ user: () throws -> PersonModel?) -> Void)
}

// MARK: - Orders store CRUD operation results

typealias PersonStoreFetchPersonCompletionHandler = (_ result: PersonStoreResult<PersonModel>) -> Void

enum PersonStoreResult<U> {
    case success(result: U)
    case failure(error: PersonStoreError)
}

// MARK: - Orders store CRUD operation errors

enum PersonStoreError: Equatable, Error
{
    case cannotFetch(String)
    case cannotCreate(String)
    case cannotUpdate(String)
    case cannotDelete(String)
}

func ==(lhs: PersonStoreError, rhs: PersonStoreError) -> Bool
{
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
    case (.cannotCreate(let a), .cannotCreate(let b)) where a == b: return true
    case (.cannotUpdate(let a), .cannotUpdate(let b)) where a == b: return true
    case (.cannotDelete(let a), .cannotDelete(let b)) where a == b: return true
    default: return false
    }
}

