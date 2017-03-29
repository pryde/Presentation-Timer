//
//  Section.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/19/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

import UIKit

class Section: NSObject, NSCoding {
    var sectionTitle: String
    var durationString: String
    var sectionDuration: TimeInterval
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sectionTitle, forKey: "sectionTitle")
        aCoder.encode(durationString, forKey: "sectionDurationString")
        aCoder.encode(Int(sectionDuration), forKey: "sectionDuration")
        //aCoder.encode(sectionDuration, forKey: "sectionDuration")
    }
    
    required init?(coder aDecoder: NSCoder) {
        sectionTitle = aDecoder.decodeObject(forKey: "sectionTitle") as! String
        durationString = aDecoder.decodeObject(forKey: "sectionDurationString") as! String
        sectionDuration = TimeInterval(aDecoder.decodeCInt(forKey: "sectionDuration"))
        //sectionDuration = aDecoder.decodeObject(forKey: "sectionDuration") as! TimeInterval
    }
    
    init(title: String, duration: TimeInterval, min: String, sec: String) {
        sectionTitle = title
        sectionDuration = duration
        
        var minString = min
        var secString = sec
        
        if (min.characters.count < 2) {
            minString = "0\(min)"
        }
        if (sec.characters.count < 2) {
            secString = "0\(sec)"
        }
        
        durationString = "\(minString):\(secString)"
    }
    
    func convertToMinSec(duration: TimeInterval) -> String {
        var sec = 0
        var min = 0
        var time = Int(duration)
        
        if (time % 60 == 0) {
           min = time / 60
        }
        else {
            while (time > 60) {
                time -= 60
                min += 1
            }
            
            sec = time
        }
        
        return ("\(min) min. \(sec) sec.")
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        return (lhs.sectionTitle == rhs.sectionTitle && lhs.sectionDuration == rhs.sectionDuration)
    }
}
