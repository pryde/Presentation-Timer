//
//  Presentation.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/19/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

import UIKit

class Presentation: NSObject, NSCoding {
    var sections: [Section]
    var title: String
    var duration: TimeInterval
    var durationString: String = ""
    var isExpanded: Bool = false
    var sectionsDisplayed: Int = 0
    
    init(title: String, duration: TimeInterval, sections: [Section]) {
        self.title = title
        self.duration = duration
        self.sections = sections
        super.init()
        self.durationString = intervalToString(interval: duration)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(Int(duration), forKey: "duration")
        //aCoder.encode(duration, forKey: "duration")
        aCoder.encode(durationString, forKey:"durationString")
        aCoder.encode(sections, forKey: "sections")
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String
        duration = TimeInterval(aDecoder.decodeCInt(forKey: "duration"))
        //duration = aDecoder.decodeObject(forKey: "duration") as! TimeInterval
        durationString = aDecoder.decodeObject(forKey: "durationString") as! String
        sections = aDecoder.decodeObject(forKey: "sections") as! [Section]
    }
    
    func intervalToString(interval: TimeInterval) -> String {
        var sec = 0
        var min = 0
        var time = Int(interval)
        
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
        
        var minString = String(min)
        var secString = String(sec)
        
        if (minString.characters.count < 2) {
            minString = "0\(minString)"
        }
        if (secString.characters.count < 2) {
            secString = "0\(secString)"
        }
        
        return ("\(minString):\(secString)")
    }
    
    static func == (lhs: Presentation, rhs: Presentation
        ) -> Bool{
        return
            (lhs.title == rhs.title && lhs.duration == rhs.duration)
    }
}
