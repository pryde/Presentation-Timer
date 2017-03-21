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
}
