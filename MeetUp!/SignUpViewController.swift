//
//  SignUpViewController.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/17/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var passWordTextField: RoundedTextField!
    @IBOutlet weak var logo: RoundUIImage!
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var rePassWordTextField: RoundedTextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    var username: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI work
        logo.translatesAutoresizingMaskIntoConstraints = false
        self.logo.setImageAndShadow(image: UIImage(named: "logo3")!)
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        backgroundImage.addSubview(blurEffectView)
        rePassWordTextField.placeholder = "Re-Enter Password"
        passWordTextField.placeholder = "Enter Password"
        emailTextField.placeholder = "Enter Email Address"
        nameTextField.placeholder = "Enter Your Name"
       // Text Field delegates
        passWordTextField.delegate = self
        emailTextField.delegate = self
        rePassWordTextField.delegate = self
        nameTextField.delegate = self
 
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func createAccount(_ sender: LoginButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passWordTextField.text else { return }
        guard let name = nameTextField.text else { return }
        
        // YOUR CODE HERE
        if password.characters.count < 6 {
            let alert = UIAlertController(title: "Invalid Password", message: "Password length must be at least 6 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {
            (user, error) in
            if error != nil {
                print(error!)
                return
            }
            let changeUserName = FIRAuth.auth()?.currentUser?.profileChangeRequest()
            changeUserName?.displayName = name
            changeUserName?.commitChanges(completion: {
                error in
                if error != nil {
                    print(error!)
                    return
                }
            })
            self.username = name
            FIRDatabase.database().reference().child(firUsers).childByAutoId().setValue(name)
            self.performSegue(withIdentifier: "createdAccount", sender: nil)
        })

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "createdAccount" {
                if let dest = segue.destination as? EventViewController {
                    dest.username = self.username
                }
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
