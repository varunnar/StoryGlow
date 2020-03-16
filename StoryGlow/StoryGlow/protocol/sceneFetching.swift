//
//  sceneFetching.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/15/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation

protocol SceneFetching {
    func fetchAllScenes() -> [scene]
    func fetchScene(_ indexVal: Int) -> scene?
}
