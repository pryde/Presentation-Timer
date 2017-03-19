//
//  SetPresentationViewController.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/18/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

// TODO: Add check for sum(section duration) = presentationLength
//       I'm sure there's more...

import UIKit

class SetPresentationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var presentationTime: TimeInterval = 0
    var sections: [Section] = []
    var section: Section!
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Pass data through "done" unwind segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "done" {
            presentationTime = (datePicker?.countDownDuration)!
            
            let mainViewController = segue.destination as! MainViewController
            
            mainViewController.presentationLength = presentationTime
        }
    }
    
    // MARK: TableView Delegate, DataSource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Section 0, containing presentation sections, should have rows = sections
        // Section 1, containing add button, should have rows = 1
        if (section == 0) {
            return sections.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        // Get a new or recycled cell
        if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
            
            (cell as! SectionCell).titleLabel.text = sections[indexPath.row].sectionTitle
            (cell as! SectionCell).durationLabel.text = sections[indexPath.row].durationString
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddCell
        }
        
        // Set the text on the cell with the name of the section, and its duration
        
        
        return cell
    }
    
    //MARK: Unwind to set presentation
    @IBAction func UnwindToSetPresentation(unwindSegue: UIStoryboardSegue) {
        print(sections[0].sectionTitle)
        
        if let index = sections.index(of: section) {
            let indexPath = NSIndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
        }
    }
}
