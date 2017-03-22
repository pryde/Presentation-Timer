//
//  ViewPresentationController.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/19/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

import UIKit

class ViewPresentationController: UITableViewController {
    var presentationList: PresentationList!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presentationList.presentations.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (presentationList.presentations[section].isExpanded == false) {
            return 1
        }
        else {
            return (presentationList.presentations[section].sectionsDisplayed + 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        var cell: UITableViewCell
        
        if (indexPath.row == 0){
            cell = tableView.dequeueReusableCell(withIdentifier: "PresentationCell", for: indexPath) as! PresentationCell
            
            let presentation = presentationList.presentations[indexPath.section]
            
            (cell as! PresentationCell).titleLabel.text = presentation.title
            (cell as! PresentationCell).durationLabel.text = presentation.durationString
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
            
            let section = presentationList.presentations[indexPath.section ].sections[indexPath.row - 1]
            
            (cell as! SectionCell).titleLabel.text = section.sectionTitle
            (cell as! SectionCell).durationLabel.text = section.durationString
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number at \(indexPath.section), \(indexPath.row)!")
        
        let presentation = presentationList.presentations[indexPath.section]
        
        if (presentationList.presentations[indexPath.section].isExpanded == false) {
            presentationList.presentations[indexPath.section].isExpanded = true
            
            expandCell(presentation: presentation, indexPath: indexPath)
        }
        else {
            collapseCell(presentation: presentation, indexPath: indexPath)
            
            presentationList.presentations[indexPath.section].isExpanded = false
        }
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presentationList.moveItemAtIndex(fromIndex: sourceIndexPath.section, toIndex: destinationIndexPath.section)
        NSLog("Old row: \(sourceIndexPath.section) New row: \(destinationIndexPath.section)")
    }
    
    func expandCell(presentation: Presentation, indexPath: IndexPath) {
        for index in 0 ..< presentation.sections.count {
            NSLog("Inserting cell \(index + 1)")
            presentation.sectionsDisplayed += 1
            let newIndexPath = NSIndexPath(row: index + 1, section: indexPath.section)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .top)
        }
    }
    
    @IBAction func toggleEditingMode(sender: UIBarButtonItem) {
        if isEditing {
            sender.title = "Edit"
            setEditing(false, animated: true)
        }
        else {
            sender.title = "Done"
            setEditing(true, animated: true)
        }
    }
    
    
    func collapseCell(presentation: Presentation, indexPath: IndexPath) {
        for index in 0 ..< presentation.sectionsDisplayed {
            NSLog("Deleting cell \(index + 1)")
            NSLog("Sections displayed: \(presentation.sectionsDisplayed)")
            presentation.sectionsDisplayed -= 1
            let newIndexPath = NSIndexPath(row: 1, section: indexPath.section)
            tableView.deleteRows(at: [newIndexPath as IndexPath], with: .top)
        }
    }

}
