//
//  HandViewController.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 2/24/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class HandViewController: UIViewController, OptionViewController {
    //  Storyboard Outlets
    @IBOutlet weak var handPicker: UISegmentedControl!
    @IBOutlet weak var continueButton: UIButton!
    
    //  Class Properties
    var fromMenu = false
    
    //  UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if fromMenu {
            continueButton.isHidden = true
        } else {
            continueButton.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let hand = UserDefaults.standard.string(forKey: HAND) {
            for i in 0..<handPicker.numberOfSegments {
                if handPicker.titleForSegment(at: i) == hand {
                    handPicker.selectedSegmentIndex = i
                    break
                }
            }
        } else {
            handPicker.selectedSegmentIndex = -1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let hand = handPicker.titleForSegment(at: handPicker.selectedSegmentIndex)
        UserDefaults.standard.set(hand, forKey: HAND)
        
        print(UserDefaults.standard.string(forKey: HAND) ?? "Not set")
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
    }

    //  Storyboard Actions
}
