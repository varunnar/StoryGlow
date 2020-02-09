//
//  NotificationFile.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/2/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation
import RxLifxApi

class lightNotification: LightsChangeDispatcher{
    let notify: NotificationCenter = NotificationCenter.default
    func notifyChange(light: Light, property: LightPropertyName, oldValue: Any?, newValue: Any?) {
        notify.post(name: NSNotification.Name(rawValue: "LightsChange"), object: light)
    }
    
    func lightAdded(light: Light) {
        notify.post(name: NSNotification.Name(rawValue: "LightAdded"), object: light)
    }
}
