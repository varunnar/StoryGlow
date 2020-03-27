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
    
    let cellView: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.red
       view.layer.cornerRadius = 10
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
   }()
       
   let SceneLabel: UILabel = {
       let label = UILabel()
       label.textColor = UIColor.white
       label.font = UIFont.boldSystemFont(ofSize: 16)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(SceneLabel)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        SceneLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        SceneLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        SceneLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        SceneLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        
        
    }
    
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//

//
//    func set(cellHold: CellData)
//    {
//        environmentName.text = cellHold.title
//    }
//
//    func configEnvironmentName()
//    {
//        environmentName.translatesAutoresizingMaskIntoConstraints = false
//        environmentName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        environmentName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        environmentName.heightAnchor.constraint(equalToConstant: 80).isActive = true
//    }

}
