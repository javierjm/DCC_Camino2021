
import Foundation

struct K {
    struct NotificationKey {
        static let welcome = "kWelcomeNotif"
    }
    
    struct Path {
//        static let Documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        static let Tmp = NSTemporaryDirectory()
    }
    
    struct UserDefautls {
        static let lastTweetID = "kLastTweet"
        static let currentUser = "kCurrentUser"
    }
}

