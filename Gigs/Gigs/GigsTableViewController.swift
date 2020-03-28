//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by krikaz on 3/15/20.
//  Copyright © 2020 thewire. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()
    var df = ISO8601DateFormatter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            // fetch gigs here
            gigController.getAllGigs { (result) in
                if let gigs = try? result.get() {
                    DispatchQueue.main.async {
                        self.gigController.gigs = gigs
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        cell.textLabel?.text = gigController.gigs[indexPath.row].title
//        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//        let myString = df.string(from: gigController.gigs[indexPath.row].dueDate)
//        df.dateFormat = "dd-MMM-yyyy"
//        let myDate = df.date(from: myString)
        cell.detailTextLabel?.text = df.string(from: gigController.gigs[indexPath.row].dueDate)

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        }
        
        if segue.identifier == "ShowGigSegue" {
            if let showVC = segue.destination as? GigDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                showVC.gigController = gigController
                showVC.gig = gigController.gigs[indexPath.row]
            }
        }
        
        if segue.identifier == "AddGigSegue" {
            if let addVC = segue.destination as? GigDetailViewController {
                addVC.gigController = gigController
            }
        }
    }
    

}
