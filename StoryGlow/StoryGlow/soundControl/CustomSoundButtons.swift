//
//  CustomSoundTableViewButtons.swift
//  StoryGlow
//
//  Created by Jennifer Mah on 2/25/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class CustomSoundButtons:UIButton{
    //This is overwriting a programable button
    override init(frame:CGRect){
        super.init(frame: frame)
        setupButton()
    }
    
    //used for storyboards
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton(){
        
    }
}
