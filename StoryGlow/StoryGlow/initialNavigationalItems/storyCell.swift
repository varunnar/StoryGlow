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
    
    let cellView: UIView = {
           let view = UIView()
           view.backgroundColor = UIColor.red
           view.layer.cornerRadius = 10
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
    }()
    
    let storyLabel: UILabel = {
        let label = UILabel()
        label.text = "Day 1"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
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
        //addSubview(storyName)
        //configStoryName()
        setupView()
    }
    
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(storyLabel)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        storyLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        storyLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        storyLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        storyLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
    }
    
    func set(cellHold: CellData)
    {
        storyName.text = cellHold.title
        storyName.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func configStoryName()
    {
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        storyLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        storyLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        storyLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    

}
