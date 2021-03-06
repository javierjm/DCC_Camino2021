//
//  LoginViewController.swift
//  Figueres2018
//
//  Created by Javier Jara on 12/6/16.
//  Copyright (c) 2016 Data Center Consultores. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import TwitterKit
import SVProgressHUD

protocol LoginViewControllerInput {
    func displayPerson(_ viewModel: Login.FetchUser.ViewModel)
    func displayError(_ error: Login.FetchUser.Error)
}

protocol LoginViewControllerOutput {
    func fetchUser(request: Login.FetchUser.Request)
    var person:PersonModel? {get}
}

class LoginViewController: UIViewController, LoginViewControllerInput, UITextFieldDelegate {
    var output: LoginViewControllerOutput!
    var router: LoginRouter!
    var twitterW: TwitterWorker!
    
    @IBOutlet var idTextFields: [UITextField]!
    @IBOutlet weak var id1TextField: UITextField!
    @IBOutlet weak var id2TextField: UITextField!
    @IBOutlet weak var id3TextField: UITextField!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LoginConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Display logic
    
    func displayPerson(_ viewModel: Login.FetchUser.ViewModel) {
        // NOTE: Display the result from the Presenter
        print("Full Name is: \(viewModel.displayedPerson.nombre) \(viewModel.displayedPerson.apellido1) \(viewModel.displayedPerson.apellido2)")
                SVProgressHUD.dismiss()
        OperationQueue.main.addOperation {
                 self.performSegue(withIdentifier: "SucessLoginSegueId", sender: self)
        }
    }
    
    func displayError(_ error: Login.FetchUser.Error) {
        print("Error Title: \(error.title), Error Message: \(error.message)")
        SVProgressHUD.dismiss()
    }

    
    // MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let index = idTextFields.index(of: textField) {
            if index < idTextFields.count - 1 {
                let nextTextField = idTextFields[index + 1]
                nextTextField.becomeFirstResponder()
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if (string.rangeOfCharacter(from: CharacterSet.letters) != nil) {
            return false
        }
        
        
        if (id1TextField.text?.characters.count)! >= 1 && range.length == 0 && textField.tag == 0{
            id2TextField.text = string
            id2TextField.becomeFirstResponder()
            return false
        }
        
        if (id2TextField.text?.characters.count)! >= 4 && range.length == 0 && textField.tag == 1{
            id3TextField.text = string
            id3TextField.becomeFirstResponder()
            return false
        }
        
        if (id3TextField.text?.characters.count)! >= 4 && range.length == 0 && textField.tag == 2{
            id3TextField.resignFirstResponder()
            return false
        }
        
        return true
        
    }
    // MARK: - Event Handling
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        
        switch(id1TextField.text, id2TextField.text, id3TextField.text){
        case let (.some(firstNumber), .some(secondNumber), .some(thirdNumber)):
            print("La cedula a consultar es: \(firstNumber)-\(secondNumber)-\(thirdNumber)")
            let fullId = firstNumber+secondNumber+thirdNumber
            print("Y la cedula formateada es: \(fullId)")
            let request = Login.FetchUser.Request(id:fullId)
            output.fetchUser(request: request)
            
        default:
            // Must show an error to user 
            print("Por favor ingrese una cedula válida")
        }
    }
}
