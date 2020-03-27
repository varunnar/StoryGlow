//
//  DataModel.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/9/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation
import UIKit

class GlobalVar: Codable{
    struct GlobalItems:Codable {
        static var storyArray = [Story]() //By adding this information in a struct, we can reach this information from anywhere
        static var firstOpening = true
    }
    struct Story: Codable{ //This is the class defining what is needed in a story
        var storyName: String
        var sceneArray = [Scenes]()
    }//This array holds the list of settings for that story
    struct Scenes: Codable{ //This class defines a single setting within a single story
        var sceneName: String
        var buttonInfo = [SoundAffects](repeating: SoundAffects(soundName: "", soundVal: ""), count: 6)//this holds the name and sound name for every button. This defined for a size of 6 because there are 6 buttons
        //var colorVal = UIColor.white //This holds the color previously selected. May have to change to a different type of int value
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        var startText = "" //Store the start infomation for each scene
        var endText = "" //Store the end information from each scene
    }
    struct SoundAffects: Codable{ //Holds the information for a single button on one setting
            var soundName: String //The name given to the button by the user
            var soundVal: String //this may be a different audio type
    }
}
