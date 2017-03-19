//
//  AddSectionViewController.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/19/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

import UIKit

class AddSectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var minPicker: UIPickerView!
    @IBOutlet var secPicker: UIPickerView!
    @IBOutlet var titleField: UITextField!
    
    let elements = Array(0 ... 60)
    var section: Section!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minPicker.delegate = self
        secPicker.delegate = self
        minPicker.dataSource = self
        secPicker.dataSource = self
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
        if (segue.identifier == "done") {
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
    
    func convertToSec(min: String, sec: String) -> Int {
        let minInt = Int(min)
        let secInt = Int(sec)
        
        return (minInt! * 60) + secInt!
        
    }
}
