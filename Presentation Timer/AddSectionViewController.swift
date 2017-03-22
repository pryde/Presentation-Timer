//
//  AddSectionViewController.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/19/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

import UIKit

class AddSectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet var minPicker: UIPickerView!
    @IBOutlet var secPicker: UIPickerView!
    @IBOutlet var titleField: UITextField!
    
    let elements = Array(0 ... 60)
    var section: Section!
    var sections: [Section]!
    var isEditingSection: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minPicker.delegate = self
        secPicker.delegate = self
        minPicker.dataSource = self
        secPicker.dataSource = self
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return elements.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(elements[row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToSetPresentation") {
            
            if (isEditingSection) {
                NSLog("Error occurs past line 57")
                NSLog("\(section.sectionTitle)")
                let sectionIndex = sections.index(of: section)
                NSLog("\(sectionIndex)")
                
                let min = minPicker.selectedRow(inComponent: 0)
                let sec = secPicker.selectedRow(inComponent: 0)
                
                if let title = titleField.text {
                    section = Section(title: title, duration: TimeInterval((min * 60) + sec), min: String(min), sec: String(sec))
                }
                
                let setView = segue.destination as! SetPresentationViewController
                setView.sections[sectionIndex!] = section
                setView.section = section
            }
            else {
                let min = minPicker.selectedRow(inComponent: 0)
                let sec = secPicker.selectedRow(inComponent: 0)
                
                if let title = titleField.text {
                    section = Section(title: title, duration: TimeInterval((min * 60) + sec), min: String(min), sec: String(sec))
                }
                
                let setView = segue.destination as! SetPresentationViewController
                setView.sections.append(section)
                setView.section = section
            }
        }
    }
    
    func convertToSec(min: String, sec: String) -> Int {
        let minInt = Int(min)
        let secInt = Int(sec)
        
        return (minInt! * 60) + secInt!
        
    }
}
