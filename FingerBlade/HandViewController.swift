//
//  HandViewController.swift
//  FingerBlade
//
//  Created by Eric T Cormack on 2/24/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class HandViewController: UIViewController {
    //  Storyboard Outlets
    @IBOutlet weak var handPicker: UISegmentedControl!
    
    //  UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let hand = handPicker.titleForSegment(at: handPicker.selectedSegmentIndex)
        UserDefaults.standard.set(hand, forKey: "Hand")
        
        print(UserDefaults.standard.value(forKey: "Hand") as? String ?? "Not set")
    }

    //  Storyboard Actions
}
