//
//  SoundCell.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/24/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class SoundCell: UITableViewCell {
    
    var playButton  = UIButton(type: .custom)
    var addButton = UIButton(type: .custom)
    var soundName = UILabel()
    var TableViewIndex = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(playButton)
        addSubview(soundName)
        addSubview(addButton)
        
        
        configureTitleLabel()
        configurePlayButton()
        configureAddButton()
        
        setUpPlayButtonConstraints()
        setUpAddButtonConstraints()
        setTitleConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cellHold: CellData)
    {
        soundName.text = cellHold.title
        soundName.font = UIFont.boldSystemFont(ofSize: 20)
        playButton = cellHold.button

    }
    
    func configurePlayButton(){
        playButton.setImage(UIImage(named: "play.png"), for: .normal)
    }
    
    func configureAddButton(){
         addButton.setImage(UIImage(named: "add.png"), for: .normal)
     }
     
    
    func configureTitleLabel(){
        soundName.numberOfLines = 0
        soundName.adjustsFontSizeToFitWidth = true
    }
    
    //UI set up constraints
    func setUpAddButtonConstraints()
    {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    
    func setUpPlayButtonConstraints()
    {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    func setTitleConstraints()
    {
        soundName.translatesAutoresizingMaskIntoConstraints = false
        soundName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        soundName.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 20).isActive = true
        soundName.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -20).isActive = true
        soundName.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}

