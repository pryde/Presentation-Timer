//
//  Section.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/19/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

import UIKit

class Section: Equatable {
    var sectionTitle: String
    var durationString: String
    var sectionDuration: TimeInterval
    
    init(title: String, duration: TimeInterval, min: String, sec: String) {
        sectionTitle = title
        sectionDuration = duration
        
        durationString = "\(min) min. \(sec) sec."
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
