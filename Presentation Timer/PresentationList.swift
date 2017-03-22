//
//  PresentationList.swift
//  Presentation Timer
//
//  Created by Chase Bussey on 3/19/17.
//  Copyright © 2017 Chase Bussey. All rights reserved.
//

import UIKit

class PresentationList {
    var presentations = [Presentation]()
    
    func createPresentation(presentation: Presentation) -> Presentation {
        presentations.append(presentation)
        return presentation
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        NSLog("moveItemAtIndex called with fromIndex \(fromIndex) and toIndex \(toIndex)")
        
        if (fromIndex == toIndex) {
            return
        }
        
        // Get reference to object being moved so you can reinsert it
        let movedItem = presentations[fromIndex]
        
        // Remove item from array
        presentations.remove(at: fromIndex)
        
        // Insert in new location
        presentations.insert(movedItem, at: toIndex)
        
        NSLog("Moving from index \(fromIndex) to \(toIndex)")
    }
}
