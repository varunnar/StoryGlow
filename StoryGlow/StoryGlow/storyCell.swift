//
//  storyCell.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/1/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class storyCell: UITableViewCell {
    
    var storyName = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(storyName)
        configStoryName()
    }
    
    func set(cellHold: CellData)
    {
        storyName.text = cellHold.title
        storyName.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func configStoryName()
    {
        storyName.translatesAutoresizingMaskIntoConstraints = false
        storyName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        storyName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        storyName.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    

}
