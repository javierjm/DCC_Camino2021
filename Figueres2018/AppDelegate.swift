//
//  AppDelegate.swift
//  Figueres2018
//
//  Created by Javier Jara on 12/6/16.
//  Copyright © 2016 Data Center Consultores. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import TwitterKit
import UserNotifications
import SwiftyJSON
import Alamofire
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dateFormatter = DateFormatter()
    let clientSecret = "3674277790370273599"
    let clientId = "3MVG9jfQT7vUue.HqM6QpUVnyetAT0hnMDeHFwJyRLEUdv90PB0P31sRrLQu_dSkdLJsC4skCo5VDx2MBnnup"
    let username = "entebbe@incompany.cr.WSapp"
    let password = "Laluchasinfin2017"

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Twitter.self])
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            
        }
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
                    startAlamofireOauth()

        
//        let keychain = Keychain(service: "com.datacenter.figueres2018")
//        if let token = keychain["access_token"] {
//            print("There is a token already installed in keychain and is: \(token)")
//            fetchuser(userId: "110400781", access_token: token)

//
//        } else {
//            startAlamofireOauth()
//        }
        return true
    }

    // Support for background fetch
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let api = TwitterAPI()
        let twitterW = TwitterWorker(twitterAPIStore: api)
        twitterW.fetchLatestTweets { (tweets)->Void in
            if tweets.count > 0 {
                completionHandler(.newData)
                for tweet in tweets {
                    print(tweet.text)
                    
                    
                    let content = UNMutableNotificationContent()
                    content.title = "New Tweet From Figueres"
                    content.subtitle = tweet.tweetID
                    content.body = tweet.text
                    UserDefaults.standard.set(tweet.tweetID, forKey: K.UserDefautls.lastTweetID)
                    // Deliver the notification in five seconds.
                    content.sound = UNNotificationSound.default()
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                                    repeats: false)
                    
                    // Schedule the notification.
                    let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
                    let center = UNUserNotificationCenter.current()
                    center.add(request, withCompletionHandler:nil)
                                        
                }
            } else {
                completionHandler(.noData)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        // you should probably first check if this is the callback being opened
        if url.scheme == "salesforce" {
            // if your oauth2 instance lives somewhere else, adapt accordingly
//            oauth2.handleRedirectURL(url)
            return true
        }
        return false
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appcoda.CoreDataDemo" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "CoreDataDemo", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CoreDataDemo.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - CSV Parser Methods
    
    func parseCSV (_ contentsOfURL: URL, encoding: String.Encoding) -> [(id:String, codelec:String, sexo: String,  fechacaduc:String,junta: String, nombre:String, apellido1:String, apellido2:String)]? {
        
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(id:String, codelec:String, sexo: String, fechacaduc:String, junta: String,  nombre:String, apellido1:String, apellido2:String)]?
        
        do {
            let content = try String(contentsOf: contentsOfURL, encoding: encoding)
            //print(content)
            items = []
            let lines:[String] = content.components(separatedBy: CharacterSet.newlines) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.range(of: "\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:Scanner = Scanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpTo("\"", into: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpTo(delimiter, into: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value as! String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < textScanner.string.characters.count {
                                textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.components(separatedBy: delimiter)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    //let item = (name: values[0], detail: values[1], price: values[2])
                    //        [(id:String, codelec:NSNumber,    sexo: NSNumber,     junta: NSNumber, fechacaduc:NSDate, nombre:String,      apellido1:String, apellido2:String)]?
                    let item = (id:values[0], codelec:values[1], sexo:values[2], fechacaduc:values[3], junta:values[4], nombre:values[5], apellido1:values[6], apellido2:values[7])
                    items?.append(item)
                }
            }
            
        } catch {
            print(error)
        }
        
        return items
    }
    
    func preloadData () {
        // Retrieve data from the source file
        if let contentsOfURL = Bundle.main.url(forResource: "padron", withExtension: "csv") {
            // Remove all the menu items before preloading
            removeData()//NSMacOSRomanStringEncoding
            if let people = parseCSV(contentsOfURL, encoding: String.Encoding.macOSRoman){
                let managedObjectContext = self.managedObjectContext
                for personP in people {
                    let personObj = NSEntityDescription.insertNewObject(forEntityName: "Person", into: managedObjectContext) as! Person
                    personObj.id =  Int32(personP.id)!
                    personObj.codelec = Int32(personP.codelec)!
                    personObj.sexo = Int32(personP.sexo)!
                    personObj.junta = Int32(personP.junta)!
                    if let dateString = dateFormatter.date(from: personP.fechacaduc) {
                        personObj.fechacaduc = dateString as Date?
                    }
                    personObj.nombre = personP.nombre.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines)
                    personObj.apellido1 = personP.apellido1.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines)
                    personObj.apellido2 = personP.apellido2.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines)
                    do {
                        try managedObjectContext.save()
                    } catch _ {
                        print ("There was an error saving the data base")
                    }
                }
                
            }
        }
    }
    
    func removeData () {
        // Remove the existing items
        let managedObjectContext = self.managedObjectContext
        
        //let fetchRequest = NSFetchRequest("Person")
        //let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Person.fetchRequest()
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        
        do {
            let menuItems = try managedObjectContext.fetch(request) as! [Person]
            for menuItem in menuItems {
                managedObjectContext.delete(menuItem)
            }
            
        } catch _ {
            print ("There was an error DELETING the data base")
        }
    }
    
    // MARK - OAuth
    
    func startAlamofireOauth() {
        
        let parameters: Parameters = [
            "grant_type": "password",
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "username": username,
            "password": password,
            "redirect_uri": "https://cs52.salesforce.com/services/oauth2/token"
        ]
        let headers: HTTPHeaders = [
            "content-type" : "application/x-www-form-urlencoded; charset=utf-8"
        ]

        //https://login.salesforce.com/services/oauth2/token
        //https://cs52.salesforce.com/services/oauth2/token
        Alamofire.request("https://cs52.salesforce.com/services/oauth2/token", method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).authenticate(user: username, password: password).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                
                guard json["error"].string == nil else {
                    print("Error returned by server: \(json["error"])")
                    let keychain = Keychain(service: "com.datacenter.figueres2018")
                    _ = try! keychain.remove("access_token")
                    
                    return
                }
                let issued_at = json["issued_at"]
                let access_token = json["access_token"].stringValue
                
                print("Access token: \(access_token), issued at: \(issued_at)")
                let keychain = Keychain(service: "com.datacenter.figueres2018")
                keychain["access_token"] = access_token
                

            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchuser(userId:String, access_token:String) {
        
        let sessionManager = SessionManager()
        sessionManager.adapter = AccessTokenAdapter(accessToken:access_token)
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(access_token)",
            "content-type" : "application/x-www-form-urlencoded; charset=utf-8"
        ]
        Alamofire.request("https://cs59.salesforce.com/services/apexrest/Contacts/\(userId)", method: .get , encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                guard json["error"].string == nil else {
                    print("Error returned by server: \(json["error"])")
                    return
                }
                print (json)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
}

