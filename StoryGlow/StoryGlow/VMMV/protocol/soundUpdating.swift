//
//  soundUpdating.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/15/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation

protocol SoundUpdating {
    func add(_ newSound: sound)
    func delete(_ indexVal: Int)
    func update(_ updatedSound: sound)
}
