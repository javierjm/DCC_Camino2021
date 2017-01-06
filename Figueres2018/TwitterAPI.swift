

import UIKit
import TwitterKit

class TwitterAPI: TwiterAPIProtocol {

    func fetchLatestTweets(_ completionHandler: @escaping (_ tweets: () throws -> [Any]) -> Void) {
        let client = TWTRAPIClient()
        let params: [String:String]
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let lastTweetId = UserDefaults.standard.object(forKey: K.UserDefautls.lastTweetID)
        
        if ((lastTweetId) != nil){
            params = ["user_id": "26883683", "since_id" : lastTweetId as! String]
        } else {
            params = ["user_id": "26883683", "count" : "1"]
        }
        
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            defer{completionHandler({return []})}
            if connectionError != nil {
                print("Error: \(connectionError)")
            }else {
                do {
                    guard let jsonArray =  try JSONSerialization.jsonObject(with: data!, options: []) as? [ Any]
                        else { return completionHandler({return []}) }
                    let twittsArr = TWTRTweet.tweets(withJSONArray:jsonArray)
                    completionHandler({return twittsArr})
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
    }

}
