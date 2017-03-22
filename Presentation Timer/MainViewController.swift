//
//  MainViewController.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/11/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

// TODO: Implement UITableView DataSource and Delegate -- done
//       Populate tableview -- done
//       Outer circle ui element
//       Alllll the fucking settings
//       Data model updates:
//          Presentation List
//              each presentation should store its own sections -- done
//              should persist
//              view all presentations element of tableview -- done

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
    
    // MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        for i in 0 ..< self.view.subviews.count {
            self.view.subviews[i].backgroundColor = UIColor.darkGray
        }
        self.view.backgroundColor = UIColor.darkGray
        */
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        animateInset()
        
        animateTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: Pass data through show segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ViewPresentations") {
            let viewPresentationController = segue.destination as! ViewPresentationController
            viewPresentationController.presentationList = self.presentationList
        }
    }
    
    // MARK: Display inset circle: called on viewDidLoad -- does not work, don't know why
    func animateInset() {
        let Pop = self.view.subviews[1]
        
        let circle = Pop
        
        
        //var insetCircle = CAShapeLayer();
        
        // Initializes circlePath using an inscribed oval in circle.bounds
        //let circlePath = UIBezierPath(ovalIn: (circle.bounds).insetBy(dx: 5/2.0, dy: 5/2.0))
        // Initilizes circlePath using circle arc with radius 150, startAngle 0, endAngle 360 doesn't work?
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circle.bounds.midX, y: circle.bounds.midY), radius: 150, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat((-M_PI_2) + (M_PI * 2)), clockwise: true)
        
        let insetCircle = CAShapeLayer();
        insetCircle.path = circlePath.cgPath
        insetCircle.strokeColor = UIColor.black.cgColor
        insetCircle.fillColor = UIColor.clear.cgColor
        insetCircle.lineWidth = 9.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.duration = 1
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        insetCircle.add(animation, forKey: "ani")
    }
 
    // MARK: Start timer function
    func animateTimer() {
        let Pop = self.view.subviews[1]
        
        let circle = Pop
        
        
        let progressCircle = CAShapeLayer();
        
        // Initializes circlePath using an inscribed oval in circle.bounds
        //let circlePath = UIBezierPath(ovalIn: (circle.bounds).insetBy(dx: 5/2.0, dy: 5/2.0))
        // Initilizes circlePath using circle arc with radius 150, startAngle 0, endAngle 360 doesn't work?
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circle.bounds.midX, y: circle.bounds.midY), radius: 150, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat((-M_PI_2) + (M_PI * 2)), clockwise: true)
        
        //progressCircle = CAShapeLayer ()
        progressCircle.path = circlePath.cgPath
        progressCircle.strokeColor = UIColor.orange.cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = 5.0
        
        circle.layer.addSublayer(progressCircle)
        
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.duration = presentationLength
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        progressCircle.add(animation, forKey: "ani")
    }
    
    func clearTimer() {
        let Pop = self.view.subviews[1]
        
        let circle = Pop
        
        var progressCircle = CAShapeLayer();
        
        // Initializes circlePath using an inscribed oval in circle.bounds
        //let circlePath = UIBezierPath(ovalIn: (circle.bounds).insetBy(dx: 5/2.0, dy: 5/2.0))
        // Initilizes circlePath using circle arc with radius 150, startAngle 0, endAngle 360 doesn't work?
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circle.bounds.midX, y: circle.bounds.midY), radius: 150, startAngle: CGFloat(-M_PI / 2.0), endAngle: CGFloat((3 * M_PI) * 2.0), clockwise: true)
        
        progressCircle = CAShapeLayer ()
        progressCircle.path = circlePath.cgPath
        progressCircle.strokeColor = UIColor.white.cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = 5.0
        
        circle.layer.addSublayer(progressCircle)
    }
    
    // MARK: Start button press
    @IBAction func startTimer(sender: Any?) {
        clearTimer()
        animateTimer()
 
        countdown = 0
        
        if ((selectedPresentation?.sections.count)! > 0) {
            currSectionDuration = (selectedPresentation?.sections[0].sectionDuration)!
        }
        else {
            currSectionDuration = (selectedPresentation?.duration)!
        }
        
        labelUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        
        
        // This one works though
        _ = Timer.scheduledTimer(withTimeInterval: presentationLength, repeats: false) {_ in
            for _ in 0 ... 2 {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            }
            //self.clearTimer()
            print("Timer Completed")
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
        
        if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell", for: indexPath) as! ViewPresentationsCell
        }
        else if (indexPath.section > 0 && indexPath.row == 0){
            cell = tableView.dequeueReusableCell(withIdentifier: "PresentationCell", for: indexPath) as! PresentationCell
            
            let presentation = presentationList.presentations[indexPath.section - 1]
            
            (cell as! PresentationCell).titleLabel.text = presentation.title
            (cell as! PresentationCell).durationLabel.text = presentation.durationString
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
            
            let section = presentationList.presentations[indexPath.section - 1].sections[indexPath.row - 1]
            
            (cell as! SectionCell).titleLabel.text = section.sectionTitle
            (cell as! SectionCell).durationLabel.text = section.durationString
        }
        
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
