//
//  StoryRepository.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/15/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation

class StoryRepository {
    private var allStories = [story]()
    
    init() { }
}

extension StoryRepository: StoryFetching {
    func fetchAllStories() -> [story] {
        return allStories
    }
    
    func fetchStory(_ indexVal: Int) -> story? {
        return allStories[indexVal]
    }
}

extension StoryRepository: StoryUpdating {
    func add(_ story: story) {
        allStories.append(story)
    }
    
    func delete(_ indexVal: Int) {
        allStories.remove(at: indexVal)
    }
    
    func update(_ story: story) {
        guard let existingStory = allStories.first(where: { $0.id == story.id }) else {
            add(story)
            return
        }
        
        delete(existingStory.id)
        add(story)
    }
}
