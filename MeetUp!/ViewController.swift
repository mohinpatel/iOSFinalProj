//
//  ViewController.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/5/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var logo: RoundUIImage!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passWordTextField: RoundedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // UI Work
        logo.translatesAutoresizingMaskIntoConstraints = false
        self.logo.setImageAndShadow(image: UIImage(named: "logo4")!)
       
        passWordTextField.placeholder = "Enter Password"
        emailTextField.placeholder = "Enter Email Address"
        // Delegates
        emailTextField.delegate = self
        passWordTextField.delegate = self
        //Firebase
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "loggedIn", sender: nil)
        }
        
    }
    
    func assignbackground(){
        let background = UIImage(named: "background")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    @IBAction func login(_ sender: LoginButton) {
        guard let emailText = emailTextField.text else { return }
        guard let passwordText = passWordTextField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: emailText, password: passwordText, completion: {
            (user, error) in
            if error != nil {
                let alert =  UIAlertController(title: "Sign in failed", message: "try again", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                alert.addAction(closeAction)
                self.present(alert, animated: true, completion:  nil)
            }
            self.performSegue(withIdentifier: "loggedIn", sender: nil)
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

