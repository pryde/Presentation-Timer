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
    let presentationArchiveURL: NSURL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("presentations.archive") as NSURL
    }()
    
    init() {
        if let archivedPresentations = NSKeyedUnarchiver.unarchiveObject(withFile: presentationArchiveURL.path!) as? [Presentation] {
            presentations += archivedPresentations
        }
    }
    
    func createPresentation(presentation: Presentation) -> Presentation {
        presentations.append(presentation)
        return presentation
    }
    
    func saveChanges() -> Bool {
        NSLog("Saving items to \(presentationArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(presentations, toFile: presentationArchiveURL.path!)
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
