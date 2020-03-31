//
//  tutorialPage.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/26/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class tutorialPage: UIViewController {
    
    var imageLabel = UILabel()
    var image = UIImage()
    var imageView = UIImageView()
    var imageLabelString = String()
    var imageString = String()
    var navBar = UINavigationBar()

    override func viewDidLoad() {
        title = "Tutorial"
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLabel()
        setupImage()
        // Do any additional setup after loading the view.
    }
    
    func setupNavigationBar()
    {
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(done))
        navigationItem.rightBarButtonItem = doneBtn
        navBar.setItems([navigationItem], animated: false)
    }
    
    @objc func done(){
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "endTutorial")))
    }
    
    func setupLabel(){
        view.addSubview(imageLabel)
        imageLabel.text = imageLabelString
        imageLabel.textAlignment = .center
        imageLabel.lineBreakMode = .byWordWrapping
        imageLabel.numberOfLines = 0
        imageLabel.setContentCompressionResistancePriority(.init(rawValue: 752), for: .vertical)
        imageLabel.setContentHuggingPriority(.init(rawValue: 252), for: .vertical)
        print(imageLabelString)
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        imageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
    }
    
    func setupImage()
    {
        imageView.setContentCompressionResistancePriority(.init(rawValue: 748), for: .vertical)
        imageView.setContentHuggingPriority(.init(rawValue: 248), for: .vertical)
        imageView.setContentCompressionResistancePriority(.init(rawValue: 748), for: .horizontal)
        imageView.setContentHuggingPriority(.init(rawValue: 248), for: .horizontal)
        view.addSubview(imageView)
        print(imageString)
        image = UIImage(named: imageString)!
        imageView.image = image
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 20).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageLabel.topAnchor, constant: -10).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1118/606).isActive = true
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
