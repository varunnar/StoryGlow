//
//  soundFetching.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/15/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation

protocol SoundFetching {
    func fetchSound(_ indexVal: Int) -> sound?
}
