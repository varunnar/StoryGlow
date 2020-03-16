//
//  storyUpdating.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/15/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation

protocol StoryUpdating {
    func add(_ newStory: story)
    func delete(_ indexVal: Int)
    func update(_ updatedStory: story)
}
