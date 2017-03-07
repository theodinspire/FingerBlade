//
//  MenuViewController.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 3/6/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var handPicker: UISegmentedControl!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var storedEmail: String?
    var storedHand: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        storedEmail = UserDefaults.standard.string(forKey: "Email")
        storedHand = UserDefaults.standard.string(forKey: "Hand")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //  Handedness
        if let hand = storedHand {
            for i in 0..<handPicker.numberOfSegments {
                if handPicker.titleForSegment(at: i) == hand {
                    handPicker.selectedSegmentIndex = i
                }
            }
        }
        
        //  Email
        if let email = storedEmail {
            emailField.placeholder = email
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismissKeyboard(_ sender: UIView) {
        emailField.resignFirstResponder()
    }
    
    @IBAction func handChanged(_ sender: UISegmentedControl) {
        saveButton.isEnabled = true
    }
    
    @IBAction func emailChanged(_ sender: UITextField) {
        if emailField.text != storedEmail && validateEmail(of: emailField.text) {
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        if handPicker.titleForSegment(at: handPicker.selectedSegmentIndex) != storedHand {
            storedHand = handPicker.titleForSegment(at: handPicker.selectedSegmentIndex)
            UserDefaults.standard.set(storedHand, forKey: "Hand")
        }
        
        if validateEmail(of: emailField.text) && emailField.text != storedEmail {
            let alert = UIAlertController(title: "Subscription Confirmation", message: "By submitting this email, you agree to recieving emails regarding future products from The Odin Spire", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                self.emailField.text = ""
            })
            
            let approve = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                self.storedEmail = self.emailField.text
                self.emailField.placeholder = self.storedEmail
                self.emailField.text = ""
                UserDefaults.standard.set(self.storedEmail, forKey: "Email")
            })
            
            alert.addAction(cancel)
            alert.addAction(approve)
            
            present(alert, animated: true)
        }
        
        saveButton.isEnabled = false
    }
}
