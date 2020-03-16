//
//  scene.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/15/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit
import Foundation

struct scene: Hashable {
    let id: Int
    let sceneName: String
    let colorVal: UIColor
    let soundArray: [sound]
}
