//
//  SignInVC.swift
//  Uber App For Rider
//
//  Created by MacBook on 10/20/16.
//  Copyright © 2016 Awesome Tuts. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate {
    
    private let RIDER_SEGUE = "RiderVC";
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createToolBar()
        snowFlakes()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField{
            ScrollView.setContentOffset(CGPoint(x: 0, y: 20), animated: true)
        }
        if textField == passwordTextField{
            ScrollView.setContentOffset(CGPoint(x: 0,y: 50), animated: true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
    func createToolBar(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector (SignInVC.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        emailTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func logIn(_ sender: AnyObject) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
               
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!);
                } else {
                    UberHandler.Instance.rider = self.emailTextField.text!;
                    
                    self.emailTextField.text = "";
                    self.passwordTextField.text = "";
                    
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil);
                }
                
            });
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
    }
    @IBOutlet weak var signin: UIView!
    
    @IBAction func signUp(_ sender: AnyObject) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
               
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating A New User", message: message!);
                } else {
                    
                    UberHandler.Instance.rider = self.emailTextField.text!;
                    
                    self.emailTextField.text = "";
                    self.passwordTextField.text = "";
                    
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil);
                }
                
            });
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
        
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }

    func snowFlakes(){
        let emitter = Emitter.get(with: #imageLiteral(resourceName: "SnowFlake"))
        emitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.addSublayer(emitter)
        
    }
} // class















