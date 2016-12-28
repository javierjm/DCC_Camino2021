// Native
import UIKit
// Web
import WebKit
import TwitterKit

protocol MeetUsViewControllerInput
{
    func displaySomething(viewModel: MeetUs.Something.ViewModel)
}

protocol MeetUsViewControllerOutput
{
    func doSomething(request: MeetUs.Something.Request)
}

class MeetUsViewController: UIViewController, MeetUsViewControllerInput {
    
    var output: MeetUsViewControllerOutput!
    var router: MeetUsRouter!
    var person: PersonModel!
    var webView: WKWebView!

    @IBOutlet weak var nameLabel: UILabel!
    
    let facebookUrl = "https://m.facebook.com/Figuerescr/?fref=ts"
    let twitterUrl = "https://m.twitter.com/figuerescr"
    let youtubeUrl = "https://m.youtube.com/channel/UCPbPevKt14wKpi3I0CPVaMQ"
    let webUrl = "http://www.figueres.cr/"
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        MeetUsConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomethingOnLoad()
        self.nameLabel.text = "\(person.nombre!) \(person.apellido1!)"
        
    }
    
    // MARK: - Event handling
    
    func doSomethingOnLoad()
    {
        // NOTE: Ask the Interactor to do some work
        
        let request = MeetUs.Something.Request()
        output.doSomething(request: request)
        
        loadTwit()
    }
    
    // MARK: - Display logic
    
    func displaySomething(viewModel: MeetUs.Something.ViewModel)
    {
        // NOTE: Display the result from the Presenter
        
        // nameTextField.text = viewModel.name
    }
    
    // Button Actions 
    
    @IBAction func facebookButtonPressed(_ sender: AnyObject) {
        openWebView(facebookUrl)
    }
    
    @IBAction func twitterButtonPressed(_ sender: AnyObject) {
        openWebView(twitterUrl)
    }
    
    
    @IBAction func youtubeButtonPressed(_ sender: AnyObject) {
        openWebView(youtubeUrl)
    }
    
    @IBAction func webButtonPressed(_ sender: AnyObject) {
        openWebView(webUrl)
    }
    
    func openWebView(_ urlString: String){
        // WebViewControllerID
//        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("markerView") as MarkerViewController
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "WebViewControllerID") as! WebViewController
        vc1.url = urlString
        self.present(vc1, animated: true, completion: nil)


    }

    // MARK: - Private Methods
    
    func loadTwit() {
        // TODO: Base this Tweet ID on some data from elsewhere in your app
        
        TWTRAPIClient().loadTweet(withID: "631879971628183552") { (tweet: TWTRTweet?, error: Error?) in
            if let unwrappedTweet = tweet {
                let tweetView = TWTRTweetView(tweet: unwrappedTweet)
                tweetView.center =  CGPoint(x: self.view.center.x, y:self.topLayoutGuide.length + tweetView.frame.size.height / 2);
                self.view.addSubview(tweetView)
            } else {
                NSLog("Tweet load error: %@", error!.localizedDescription);
            }
        }
    }
    
}
