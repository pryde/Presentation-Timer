//
//  MainViewController.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/11/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

// TODO: Implement UITableView DataSource and Delegate
//       Populate tableview
//       Outer circle ui element
//       Alllll the fucking settings

import UIKit
import AudioToolbox

class MainViewController: UIViewController {
    var presentationLength: TimeInterval = 0
    //var sections: [Int]
    
    @IBOutlet var startButton: UIButton?
    
    // MARK: UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: add presentation, set duration by presentation duration
    }
    
    // MARK: Start timer function
    // WHY WON'T THIS REPEAT EVERYTIME THAT I PRESS THE FUCKING BUTTON?!?!
    func animateTimer() {
        let Pop = self.view.subviews[1]
        
        let circle = Pop
        
        //circle.bounds = CGRect(x: 0,y: 0, width: 300, height: 300);
        
        //circle.layoutIfNeeded()
        
        var progressCircle = CAShapeLayer();
        
        // Initializes circlePath using an inscribed oval in circle.bounds
        //let circlePath = UIBezierPath(ovalIn: (circle.bounds).insetBy(dx: 5/2.0, dy: 5/2.0))
        // Initilizes circlePath using circle arc with radius 150, startAngle 0, endAngle 360 doesn't work?
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circle.bounds.midX, y: circle.bounds.midY), radius: 150, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat((-M_PI_2) + (M_PI * 2)), clockwise: true)
        
        progressCircle = CAShapeLayer ()
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
        
        //circle.bounds = CGRect(x: 0,y: 0, width: 300, height: 300);
        
        //circle.layoutIfNeeded()
        
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
        animateTimer()
        /* This is delayed
        DispatchQueue.main.asyncAfter(deadline: .now() + presentationLength) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            self.clearTimer()
            print("Timer completed")
        }
 */
        // This one works though
        let timer = Timer.scheduledTimer(withTimeInterval: presentationLength, repeats: false) {_ in
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            self.clearTimer()
            print("Timer Completed")
        }
    }
    
    // MARK: Unwind Segue
    @IBAction func UnwindToMain(unwindSegue: UIStoryboardSegue) {
        print(presentationLength)
    }
    
    // MARK: UITableView functions
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    */
    /* Will need to configure this method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) 
        
        /*
        // Set the text on the cell with the properties of the question
        // that is at the nth index of items, where n = row this cell
        // will apear in on the tableview
        let section = sections[indexPath.row]
        
        // Configure the cell with the question
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        cell.titleLabel.text = question.title
        cell.authorLabel.text = question.author
        cell.dateLabel.text = dateFormatter.string(from: question.dateCreated)
        */
        return cell
    }
 */
}
