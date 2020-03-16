//
//  repository.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/15/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation
import UIKit

class Repository {
    static let shared = Repository()
    
    var storyFetcher: StoryFetching { return storyRepo }
    var storyUpdater: StoryUpdating { return storyRepo }
    
    var sceneFetcher: SceneFetching { return sceneRepo }
    var sceneUpdater: SceneUpdating { return sceneRepo }
    
    private let storyRepo = StoryRepository()
    private let sceneRepo = SceneRepository()
    
    private init() { }
}
