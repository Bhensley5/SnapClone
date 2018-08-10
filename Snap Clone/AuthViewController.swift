//
//  ViewController.swift
//  Snap Clone
//
//  Created by Brandon Hensley on 8/7/18.
//  Copyright © 2018 Brandon Hensley. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var signButton: UIButton!
    var login = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func goTapped(_ sender: Any) {
        
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                if login {
                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print("Log in successful!")
                            self.performSegue(withIdentifier: "authToSnaps", sender: nil)
                        }
                    })
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print("Sign up successful!")
                            if let user = user {
                                FIRDatabase.database().reference().child("users").child(user.uid).child("email").setValue(email)
                                self.performSegue(withIdentifier: "authToSnaps", sender: nil)
                            }
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func signTapped(_ sender: Any) {
        if login {
            goButton.setTitle("Sign Up", for: .normal)
            signButton.setTitle("Switch to Login", for: .normal)
            login = false
            
        } else {
            goButton.setTitle("Login", for: .normal)
            signButton.setTitle("Switch to Sign Up", for: .normal)
            login = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

