//
//  SelectionViewController.swift
//  FingerBlade
//
//  Created by Cormack on 3/7/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

enum Section: Int {
    case start = 0, count, cuts
}

class SelectionViewController: UITableViewController {
    let cuts = CutLine.all
    
    var samplesPerCut = 3
    var cutsSelected = [CutLine : Bool]()
    
    let optionsOffset = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sect = Section(rawValue: section) else { return 0 }
        
        switch sect {
        case .count: //  Count
            return 1
        case .cuts: //  Options
            return cuts.count + optionsOffset
        case .start: //  Begin
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sect = Section(rawValue: section) else { return nil }
        
        switch sect {
        case .count:
            return "Sample Size per Cut"
        case .cuts:
            return "Cuts for Sample"
        default:
            return nil
        }
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = (Section(rawValue: indexPath.section))!
        let row = indexPath.row
        
        switch (section, row) {
        case (.count, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "sampleCount", for: indexPath) as! SampleCountTableViewCell
            cell.delegate = self
            cell.countStepper.value = Double(samplesPerCut)
            return cell
        case (.cuts, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectAll", for: indexPath)
            return cell
        case (.cuts, let r) where r >= optionsOffset:
            let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath) as! CutMenuTableViewCell
            
            let cut = cuts[r - optionsOffset]
            cell.cut = cut
            cell.label.text = cut.rawValue
            cell.marked = cutsSelected[cut] ?? false
            cell.toggle.isOn = cell.marked
            cell.delegate = self
            
            return cell
        case (.start, _):
            return tableView.dequeueReusableCell(withIdentifier: "begin", for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (Section(rawValue: indexPath.section)!, indexPath.row) == (.cuts, 0) {
            for cut in cuts {
                cutsSelected[cut] = true
            }
            
            for rowItem in tableView.visibleCells {
                if let cell = rowItem as? CutMenuTableViewCell {
                    cell.toggle.setOn(true, animated: true)
                }
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? CutMenuTableViewCell {
            cell.marked = !cell.marked
            cell.toggle.setOn(cell.marked, animated: true)
        } else if indexPath.section == Section.start.rawValue {
            if cutsSelected.values.contains(true) {
                let destination = storyboard?.instantiateViewController(withIdentifier: "CutView") as! CutViewController
                
                var cutList = [CutLine]()
                for cut in cuts {
                    if let selection = cutsSelected[cut], selection {
                        cutList.append(cut)
                    }
                }
                
                destination.fromMenu = true
                destination.cutStore = SampleStore(cutsToMake: samplesPerCut, cutList: cutList)
                
                present(destination, animated: true, completion: nil)
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? CutViewController {
            destination.fromMenu = true
            
            var cutList = [CutLine]()
            
            for cut in cuts {
                if let selection = cutsSelected[cut], selection {
                    cutList.append(cut)
                }
            }
            
            destination.cutStore = SampleStore(cutsToMake: samplesPerCut, cutList: cutList)
        }
    }

}
