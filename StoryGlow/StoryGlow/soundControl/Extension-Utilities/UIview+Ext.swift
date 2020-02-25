//
//  UIview+Ext.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/24/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit
//Constraints
extension UIView{
    func pin(to superView:UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}
