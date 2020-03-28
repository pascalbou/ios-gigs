//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by krikaz on 3/15/20.
//  Copyright © 2020 thewire. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController?
    var gig: Gig?
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if let job = jobTextField.text, let description = descriptionTextView.text {
            let newGig = Gig(title: job, description: description, dueDate: dueDatePicker.date)
            gigController?.createGig(with: newGig, completion: { (result) in
                if let _ = try? result.get() {
                    DispatchQueue.main.async {
                        self.updateViews()
                    }
                }
            })
        }
    }
    
    private func updateViews() {
        if let gig = gig {
            jobTextField.text = gig.title
            dueDatePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
        } else {
            title = "New Gig"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
