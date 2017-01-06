
import UIKit
import TwitterKit

class TwitterWorker: NSObject {
    
    var twitterAPIStore: TwitterAPI
    
    init(twitterAPIStore:TwitterAPI) {
        self.twitterAPIStore = twitterAPIStore
    }
    
    func fetchLatestTweets(_ completionHandler: @escaping (_ tweets: [TWTRTweet]) -> Void) {
        twitterAPIStore.fetchLatestTweets {(tweets: () throws -> [Any])->Void in
            do {
                let tweets = try tweets()
                
                

                completionHandler(tweets as! [TWTRTweet])
            } catch {
                completionHandler([])
            }

        }
    }
}

protocol TwiterAPIProtocol
{
    func fetchLatestTweets(_ completionHandler: @escaping (_ tweets: () throws -> [Any]) -> Void)
}
