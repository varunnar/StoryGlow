//
//  story.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/15/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation

struct story: Hashable{
    let id: Int
    let storyName: String
    let sceneArray: [scene]
}
