//
//  MainViewController.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/11/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

// TODO:
//       Alllll the fucking settings
//       Dark theme
//       Background execution

import UIKit
import AudioToolbox

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var presentationList: PresentationList!
    var presentationLength: TimeInterval = 0
    var sections: [Section] = []
    var selectedPresentation: Presentation?
    var labelUpdateTimer: Timer?
    var countdown: Int?
    var currSection: Int = 0
    var currSectionDuration: TimeInterval = 0
    
    @IBOutlet var presentationLabel: UILabel!
    @IBOutlet var sectionLabel: UILabel!
    @IBOutlet var startButton: UIButton?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var circularProgressView: KDCircularProgress!
    
    // MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
       
                
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        if (presentationList.presentations.count > 0) {
            selectedPresentation = presentationList.presentations[0]
            
             presentationLabel.text = selectedPresentation?.intervalToString(interval: TimeInterval((Int((selectedPresentation?.duration)!))))
            
            if ((selectedPresentation?.sections.count)! > 0) {
                sectionLabel.text = selectedPresentation?.intervalToString(interval: (selectedPresentation?.sections[0].sectionDuration)!)
            }
        }
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        themeViews()
    }
    
    func themeViews() {
        let theme = ThemeManager.theme
        
        view.backgroundColor = theme.colors.BackgroundPrimary
        tableView.backgroundColor = theme.colors.BackgroundPrimary
        circularProgressView.trackColor = UIColor.darkGray
        
        theme.themeButton(button: startButton!)
        
        theme.themeLabel(label: presentationLabel, textStyle: .Title)
        theme.themeLabel(label: sectionLabel, textStyle: .Subtitle)
        
        let nav = self.navigationController?.navigationBar
        
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = theme.colors.Primary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    
    // MARK: Pass data through show segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ViewPresentations") {
            let viewPresentationController = segue.destination as! ViewPresentationController
            viewPresentationController.presentationList = self.presentationList
        }
    }
    
    // MARK: Start button press
    @IBAction func startTimer(sender: Any?) {
        if selectedPresentation != nil {
            NSLog("\(presentationLength)")
     
            circularProgressView.animate(fromAngle: 0, toAngle: 360, duration: (selectedPresentation?.duration)!, completion: nil)
            
            countdown = 0
            
            if ((selectedPresentation?.sections.count)! > 0) {
                currSectionDuration = (selectedPresentation?.sections[0].sectionDuration)!
            }
            else {
                currSectionDuration = (selectedPresentation?.duration)!
            }
            
            labelUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        }
        else {
            let alert = UIAlertController(title: "Sorry!", message: "No presentation has been selected.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateLabel() {
        countdown! += 1
        
        presentationLabel.text = selectedPresentation?.intervalToString(interval: TimeInterval((Int((selectedPresentation?.duration)!) - countdown!)))
        
        sectionLabel.text = selectedPresentation?.intervalToString(interval: TimeInterval((Int(currSectionDuration)) - countdown!))
        
        if (countdown! >= Int((selectedPresentation?.duration)!)) {
            currSection = 0
            currSectionDuration = 0
            labelUpdateTimer?.invalidate()
        }
        else if (countdown! >= Int(currSectionDuration)) {
            currSection += 1
            currSectionDuration += (selectedPresentation?.sections[currSection].sectionDuration)!
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    // MARK: Unwind Segue
    @IBAction func UnwindToMain(unwindSegue: UIStoryboardSegue) {
        print(presentationLength)
        
        tableView.reloadData()
    }
    
    // MARK: UITableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return presentationList.presentations.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        else {
            if (presentationList.presentations[section - 1].isExpanded == false) {
                return 1
            }
            else {
                return (presentationList.presentations[section - 1].sectionsDisplayed + 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        var cell: UITableViewCell
        
        let theme = ThemeManager.theme
        
        if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell", for: indexPath) as! ViewPresentationsCell
            
            cell.backgroundColor = theme.colors.BackgroundPrimary
            theme.themeButton(button: (cell as! ViewPresentationsCell).viewButton!)
        }
        else if (indexPath.section > 0 && indexPath.row == 0){
            cell = tableView.dequeueReusableCell(withIdentifier: "PresentationCell", for: indexPath) as! PresentationCell
            
            let presentation = presentationList.presentations[indexPath.section - 1]
            
            (cell as! PresentationCell).titleLabel.text = presentation.title
            (cell as! PresentationCell).durationLabel.text = presentation.durationString
            (cell as! PresentationCell).backgroundColor = theme.colors.BackgroundPrimary
            
            theme.themeLabel(label: (cell as! PresentationCell).titleLabel, textStyle: .Subtitle)
            theme.themeLabel(label: (cell as! PresentationCell).durationLabel, textStyle: .Body)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
            
            let section = presentationList.presentations[indexPath.section - 1].sections[indexPath.row - 1]
            
            (cell as! SectionCell).titleLabel.text = section.sectionTitle
            (cell as! SectionCell).durationLabel.text = section.durationString
            (cell as! SectionCell).backgroundColor = theme.colors.BackgroundPrimary
            
            theme.themeLabel(label: (cell as! SectionCell).titleLabel, textStyle: .Body)
            theme.themeLabel(label: (cell as! SectionCell).durationLabel, textStyle: .Body)
        }
        
        //cell.backgroundColor = Theme.backgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        
        if (indexPath.section > 0) {
            let presentation = presentationList.presentations[indexPath.section - 1]
            
            if (presentationList.presentations[indexPath.section - 1].isExpanded == false) {
                presentationList.presentations[indexPath.section - 1].isExpanded = true
                
                expandCell(presentation: presentation, indexPath: indexPath)
            }
            else {
                collapseCell(presentation: presentation, indexPath: indexPath)
                
                presentationList.presentations[indexPath.section - 1].isExpanded = false
            }
            
            if (presentation.sections.count > 0) {
                sectionLabel.text = presentation.sections[0].durationString
            }
            else {
                sectionLabel.text = presentation.durationString
            }
            
            selectedPresentation = presentation
            presentationLength = (selectedPresentation?.duration)!
            populateLabels()
        }
        
    }
    
    func expandCell(presentation: Presentation, indexPath: IndexPath) {
        for index in 0 ..< presentation.sections.count {
            NSLog("Inserting cell \(index + 1)")
            presentation.sectionsDisplayed += 1
            let newIndexPath = NSIndexPath(row: index + 1, section: indexPath.section)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .top)
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
    
    func populateLabels() {
        presentationLabel.text = selectedPresentation?.durationString
        if ((selectedPresentation?.sections.count)! > 0) {
            sectionLabel.text = selectedPresentation?.sections[0].durationString
        }
    }
}
