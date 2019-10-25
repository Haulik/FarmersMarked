//
//  ViewController.swift
//  FarmersMarked
//
//  Created by Thomas Haulik Barchager on 04/10/2019.
//  Copyright © 2019 Haulik. All rights reserved.
//

import FirebaseUI
import FirebaseAuth
import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

    }
    @IBAction func registerPressed(_ sender: UIButton) {
        if let usr = userName.text, let pwd = password.text {
        Auth.auth().createUser(withEmail: usr, password: pwd) { (result, error) in
                print("user created")
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let usr = userName.text, let pwd = password.text {
            Auth.auth().signIn(withEmail: usr, password: pwd) { (result, error) in
                if error == nil {
                    print("user logged in")
                    self.performSegue(withIdentifier: "goHome", sender: self)
                }else {
                    print("some error during \(error.debugDescription)")
                }
            }
        }
    }
    

}
