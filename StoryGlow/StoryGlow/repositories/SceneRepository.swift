//
//  SceneRepository.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/15/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation

class SceneRepository {
    private var allScenes = [scene]()
    
    init() { }
}

extension SceneRepository: SceneFetching {
    func fetchScene(_ indexVal: Int) -> scene? {
        return allScenes[indexVal]
    }
    
    func fetchAllScenes() -> [scene] {
        return allScenes
    } 
}

extension SceneRepository: SceneUpdating {
    func add(_ newScene: scene) {
        allScenes.append(newScene)
    }
    
    func delete(_ indexVal: Int){
        allScenes.remove(at: indexVal)
    }
    
    func update(_ updatedScene: scene) {
        guard let existingScene = allScenes.first(where: { $0.id == updatedScene.id }) else {
            add(updatedScene)
            return
        }
        delete(existingScene.id)
        add(updatedScene)
        
    }
}
