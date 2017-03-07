//
//  SubscribeViewController.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 2/24/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class SubscribeViewController: UIViewController {
    //  Story board items
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var contButton: UIButton!
    
    //  Class fields

    //  UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contButton.titleLabel?.textAlignment = .center
        contButton.setTitle("Skip", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let email = emailField.text, validateEmail(of: email) {
            let alert = UIAlertController(title: "Subscription Confirmation", message: "By submitting this email, you agree to recieving emails regarding future products from The Odin Spire", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                self.emailField.text = ""
            })
            
            let approve = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                UserDefaults.standard.set(email, forKey: "Email")
                
                print(UserDefaults.standard.value(forKey: "Email") as? String ?? "Not set")
            })
            
            alert.addAction(cancel)
            alert.addAction(approve)
            
            present(alert, animated: true)
        }
    }

    //  Storyboard actions
    @IBAction func touchOnScreen(_ sender: UIControl) {
        emailField.resignFirstResponder()
    }
    
    @IBAction func endEmailEdit(_ sender: UITextField) {
        
        let isEmail = validateEmail(of: sender.text)
        let buttonText = isEmail ? "Continue" : "Skip"
        contButton.setTitle(buttonText, for: .normal)
        contButton.sizeToFit()
    }
    
    @IBAction func emailReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    //  Other functions
}
