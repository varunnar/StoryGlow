//
//  AddSceneViewController.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/11/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class AddSceneViewController: UIViewController {
    
    let AddButton = UIButton()

    override func viewDidLoad() {
        self.title = "Add a New Scene"
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(AddButton)
        setupAddButton()

        // Do any additional setup after loading the view.
    }

    
    func setupAddButton()
    {
        AddButton.setTitle("Add a New Scene", for: .normal)
        AddButton.backgroundColor = UIColor(red:1.00, green:0.44, blue:0.57, alpha:1.00)
        AddButton.layer.cornerRadius = 10
        AddButton.addTarget(self, action: #selector(AddViewController), for: .touchUpInside)
        AddButton.translatesAutoresizingMaskIntoConstraints = false
        AddButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        AddButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        AddButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func AddViewController()
    {
        let AddPageNotification = Notification.Name("addPage")
        NotificationCenter.default.post(Notification(name: AddPageNotification))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
