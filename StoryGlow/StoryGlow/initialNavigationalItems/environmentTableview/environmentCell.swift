//
//  environmentCell.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/4/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class environmentCell: UITableViewCell {

    var environmentName = UILabel()
    
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
        addSubview(environmentName)
        configEnvironmentName()
    }
    
    func set(cellHold: CellData)
    {
        environmentName.text = cellHold.title
        environmentName.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func configEnvironmentName()
    {
        environmentName.translatesAutoresizingMaskIntoConstraints = false
        environmentName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        environmentName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        environmentName.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }

}
