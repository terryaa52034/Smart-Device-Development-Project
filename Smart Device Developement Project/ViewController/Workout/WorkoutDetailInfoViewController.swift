//
//  WorkoutDetailInfoViewController.swift
//  Smart Device Developement Project
//
//  Created by lim kei yiang on 14/7/18.
//  Copyright © 2018 ITP312. All rights reserved.
//

import UIKit
import ExpyTableView
class WorkoutDetailInfoViewController: UIViewController {

    @IBOutlet weak var expandableTableView: ExpyTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        expandableTableView.delegate = self
        expandableTableView.dataSource = self
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

}



//MARK: Basic Table View Implementation, no need to write UITableViewDataSource because ExpyTableViewDataSource is forwarding all the delegate methods of UITableView that are not handled by itself.

extension WorkoutDetailInfoViewController: ExpyTableViewDataSource {
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        //Make your customizations here.
        cell?.textLabel?.text = "Section: \(section) Row: 0"
        return cell!
    }
}

extension WorkoutDetailInfoViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Please see https://github.com/okhanokbay/ExpyTableView/issues/12
        // The cell instance that you return from expandableCellForSection: data source method is actually the first row of belonged section. Thus, when you return 4 from numberOfRowsInSection data source method, first row refers to expandable cell and the other 3 rows refer to other rows in this section.
        // So, always return the total row count you want to see in that section
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
            // If you define a cell as expandable and return it from expandingCell data source method,
            // then you will not get callback for IndexPath(row: 0, section: indexPath.section) here in cellForRowAtIndexPath
            //But if you define the same cell as -sometimes not expandable- you will get callbacks for not expandable cells here and you must return a cell for IndexPath(row: 0, section: indexPath.section) in here besides in expandingCell. You can return the same cell from expandingCell method and here.
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.textLabel?.text = "Section: \(indexPath.section) Row: \(indexPath.row) T"
            return cell!
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.textLabel?.text = "Section: \(indexPath.section) Row: \(indexPath.row) T1"
            return cell!
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.textLabel?.text = "Section: \(indexPath.section) Row: \(indexPath.row) T2"
            return cell!
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.textLabel?.text = "Section: \(indexPath.section) Row: \(indexPath.row) T"
            return cell!
        }
    }
}

extension WorkoutDetailInfoViewController: ExpyTableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If you don't deselect the row here, seperator of the above cell of the selected cell disappears.
        //Check here for detail: https://stackoverflow.com/questions/18924589/uitableviewcell-separator-disappearing-in-ios7
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        //This solution obviously has side effects, you can implement your own solution from the given link.
        //This is not a bug of ExpyTableView hence, I think, you should solve it with the proper way for your implementation.
        //If you have a generic solution for this, please submit a pull request or open an issue.
        
        print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
    }
}
