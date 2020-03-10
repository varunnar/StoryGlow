//
//  IntroPage.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/1/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit
import RxLifxApi
import RxLifx
import LifxDomain

class IntroPage: UIViewController {
    
    struct lightsStruct{
        static var lightArray = [Light]()
    }
    
    let lightService = LightService(
        lightsChangeDispatcher: lightNotification(),
        transportGenerator: UdpTransport.self,
        extensionFactories: [LightsGroupLocationService.self]
    )
    
    var addStoryButton = UIButton()
    var storyListButton = UIButton()
    var mainStackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        lightService.start()
        NotificationCenter.default.addObserver(self, selector: #selector(AddedLight), name: NSNotification.Name(rawValue: "LightAdded"), object: nil)
        self.navigationController?.navigationBar.topItem?.title = "Welcome"
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        addStoryButton.backgroundColor = .red
        storyListButton.backgroundColor = .blue
        addStoryButton.setTitle("Add Story", for: .normal)
        storyListButton.setTitle("Story List", for: .normal)
        setupStackview()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Welcome"
    }
    
    @objc func AddedLight(notification: Notification){
           if let light = notification.object as? Light{
               lightsStruct.lightArray.append(light)
               let color = HSBK(hue: UInt16(.random(in: 0...1) * Float(UInt16.max)), saturation: UInt16(.random(in: 0...1) * Float(UInt16.max)), brightness: UInt16(1 * Float(UInt16.max)), kelvin: 0)
               print(color.brightness)
               print(color.hue)
               print(color.saturation)
               let setColor = LightSetColorCommand.create(light: light, color: color, duration: 0)
               setColor.fireAndForget()
           }
       }
    
    func setupStackview()
    {
        addStoryButton.addTarget(self, action: #selector(storyNameAlert), for: .touchUpInside)
        storyListButton.addTarget(self, action: #selector(navigateToStoryList), for: .touchUpInside)
        mainStackView.addArrangedSubview(addStoryButton)
        mainStackView.addArrangedSubview(storyListButton)
        mainStackView.axis = .vertical
        configStackview()
    }
    
    func configStackview(){
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainStackView.distribution = .equalSpacing
        mainStackView.spacing = 10
        mainStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
    }
    
    @objc func storyNameAlert()
    {
        let alert = UIAlertController(title: "Story name", message: "What is the name of your story?", preferredStyle: .alert)
        alert.addTextField() //https://gist.github.com/TheCodedSelf/c4f3984dd9fcc015b3ab2f9f60f8ad51 reference to make button inaccessable
        let submitAction = UIAlertAction(title: "Next", style: .default, handler: { [unowned alert] _ in
            let answer = alert.textFields![0].text
            if (answer != ""){
                let story = GlobalVar.Story(storyName: answer!)
                GlobalVar.GlobalItems.storyArray.append(story)
                self.SceneNameAlert()
            }
            else{
                print("else")
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func SceneNameAlert()
    {
        let alert = UIAlertController(title: "Scene name", message: "What is the name of your first scene?", preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Done", style: .default, handler: { [unowned alert] _ in
            let answer = alert.textFields![0].text
            if (answer != ""){
                let scene = GlobalVar.Scenes(sceneName: answer!, colorVal: .white)
                GlobalVar.GlobalItems.storyArray[GlobalVar.GlobalItems.storyArray.count-1].sceneArray.append(scene)
                let nextScreen = PageHolder()
                nextScreen.storyIndex = GlobalVar.GlobalItems.storyArray.count-1
                self.navigationController?.pushViewController(nextScreen, animated: true)
            }
            else{
                print("else")
                alert.message = "Please make a valid scene name"
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func navigateToStoryList()
    {
        let nextScreen = storyTableView()
        nextScreen.title = "Story List"
        self.navigationController?.pushViewController(nextScreen, animated: true)
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
