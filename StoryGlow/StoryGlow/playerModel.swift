//
//  playerModel.swift
//  StoryGlow
//
//  Created by Jennifer Mah on 3/8/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation
import AVFoundation

struct playerModel {
    var player = AVPlayer(url: URL(string: "https://freesound.org/data/previews/392/392617_7383104-lq.mp3")!)
    var session: AVAudioSession?
    var playing = false
}
