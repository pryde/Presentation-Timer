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

class SetPresentationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var presentationTime: TimeInterval = 0
    var sections: [Section] = []
    var section: Section!
    var selectedSection: Section!
    // This field used only for testing
    var totalPresentations = 0
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        titleField.delegate = self
    }
    
    // MARK: - Dismiss keyboard on down swipe
    @IBAction func backgroundSwipe(_ sender: UISwipeGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Pass data through "done" unwind segue
    // MARK: deprecating current function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMain" {
            NSLog("Prepare function called")
            var presentation: Presentation
            
            presentationTime = (datePicker?.countDownDuration)!
            
            if let title = titleField.text {
                if (title != "") {
                    presentation = Presentation(title: title, duration: presentationTime, sections: sections)
                }
                else {
                    presentation = Presentation(title: "Presentation \(totalPresentations + 1)", duration: presentationTime, sections: sections)
                }
            }
            else {
                presentation = Presentation(title: "Presentation \(totalPresentations + 1)", duration: presentationTime, sections: sections)
            }
            
            let mainViewController = segue.destination as! MainViewController
            
            mainViewController.presentationList.createPresentation(presentation: presentation)
            mainViewController.presentationLength = presentationTime
            mainViewController.sections = sections
            
            totalPresentations += 1
        }
        else if segue.identifier == "editSection" {
            NSLog("Editing Section")
            let addViewController = segue.destination as! AddSectionViewController
            
            addViewController.isEditingSection = true
            NSLog("Selected section title: \(selectedSection.sectionTitle)")
            addViewController.section = selectedSection
            addViewController.sections = sections
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        let sectionMatch = sectionsMatchPresentation()
        
        NSLog("Done button pressed")
        
        if (sectionMatch == 0) {
            self.performSegue(withIdentifier: "unwindToMain", sender: self)
        }
        else if (sectionMatch > 0) {
            let alert = UIAlertController(title: "Sorry!", message: "Your sections are longer than your presentation, we can't create this presentation.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Sorry!", message: "Your sections are shorter than your presentation, we can't create this presentation.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            selectedSection = sections[indexPath.row]
            NSLog("Selected section in didSelectRowAt \(selectedSection.sectionTitle)")
            self.performSegue(withIdentifier: "editSection", sender: SectionCell.self)
        }
    }
    
    //MARK: Unwind to set presentation
    @IBAction func UnwindToSetPresentation(unwindSegue: UIStoryboardSegue) {
        //print(sections[0].sectionTitle)
        
        tableView.reloadData()
        /*
        if let index = sections.index(of: section) {
            let indexPath = NSIndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
        }
 */
    }
    
    // MARK: check sum of section times against presentationTime
    //       returns 0 if section times = presentationTime
    //               1 if section times > presentationTime
    //               -1 if section times < presentationTime
    func sectionsMatchPresentation() -> Int {
        var sectionSum = 0
        
        presentationTime = (datePicker?.countDownDuration)!
        
        if (sections.count > 0) {
            for section in sections {
                sectionSum += Int(section.sectionDuration)
            }
            
            NSLog("Presentation time: \(presentationTime) Section time: \(sectionSum)")
        
            if (sectionSum == Int(presentationTime)) {
                return 0
            }
            else if (sectionSum > (Int(presentationTime))) {
                return 1
            }
            else {
                return -1
            }
        }
        else {
            return 0
        }
    }
}
