//
//  SoundRepository.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/15/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation

class SoundRepository {
    private var allSounds = [sound]()
    
    init() { }
}

extension SoundRepository: SoundFetching {
    func fetchSound(_ indexVal: Int) -> sound? {
        return allSounds[indexVal]
    }
}

extension SoundRepository: SoundUpdating {
    func add(_ newSound: sound) {
        allSounds.append(newSound)
    }
    
    func update(_ updatedSound: sound) {
        guard let existingSound = allSounds.first(where: { $0.id == updatedSound.id }) else {
            add(updatedSound)
            return
        }
        delete(existingSound.id)
        add(updatedSound)
    }
    
    func delete(_ indexVal: Int) {
        allSounds.remove(at: indexVal)
    }
}
