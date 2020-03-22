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

//Initial page the user comes across where they can create a story or look at their story list

class IntroPage: UIViewController {
    
    var DataControllerInstance = DataController()
    
    struct lightsStruct{
        static var lightArray = [Light]() //holds all lights in an array within a struct so it is accessible on any file
    }
    
    //setups up light services
    let lightService = LightService(
        lightsChangeDispatcher: lightNotification(),
        transportGenerator: UdpTransport.self,
        extensionFactories: [LightsGroupLocationService.self]
    )
    
    //buttons and stackview initializing
    var addStoryButton = UIButton()
    var storyListButton = UIButton()
    var mainStackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let previousStories = DataControllerInstance.getStoriesFromDisk()
        GlobalVar.GlobalItems.storyArray = previousStories
        print("InModel")
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(goingToBackEnd), name: UIApplication.willResignActiveNotification, object: nil)
        lightService.start() //start looking for lights
        NotificationCenter.default.addObserver(self, selector: #selector(AddedLight), name: NSNotification.Name(rawValue: "LightAdded"), object: nil) //notification for when light is added
        self.navigationController?.navigationBar.topItem?.title = "Welcome" //set top title
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        addStoryButton.backgroundColor = .red
        storyListButton.backgroundColor = .blue
        addStoryButton.setTitle("Add Story", for: .normal)
        storyListButton.setTitle("Story List", for: .normal)
        addStoryButton.layer.cornerRadius = 10
        storyListButton.layer.cornerRadius = 10

        setupStackview()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Welcome"
    }
    
    //function for when light is added, randomizes color in order to show user light is connected
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
    
    //MARK: Setup and Constraints
    
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
    
    //Function that is prompted when user pressed the "Add Story" button. Alert is triggered where the user can name their story
    @objc func storyNameAlert()
    {
        let alert = UIAlertController(title: "Story name", message: "What is the name of your story?", preferredStyle: .alert)
        alert.addTextField() //https://gist.github.com/TheCodedSelf/c4f3984dd9fcc015b3ab2f9f60f8ad51 reference to make button inaccessable
        let submitAction = UIAlertAction(title: "Next", style: .default, handler: { [unowned alert] _ in
            let answer = alert.textFields![0].text
            if (answer != ""){ //if story name exists
                self.SceneNameAlert(storyName: answer!)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    //Function is called from storyNameAlert(). Once user has made a storyname prompts them to make a scene name as well
    func SceneNameAlert(storyName: String)
    {
        let alert = UIAlertController(title: "Scene name", message: "What is the name of your first scene?", preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Done", style: .default, handler: { [unowned alert] _ in
            let answer = alert.textFields![0].text
            if (answer != ""){ //if scene name exists
                var story = GlobalVar.Story(storyName: storyName)
                let scene = GlobalVar.Scenes(sceneName: answer!)
                story.sceneArray.append(scene)
                GlobalVar.GlobalItems.storyArray.append(story)
                
                let nextScreen = PageHolder()
                nextScreen.storyIndex = GlobalVar.GlobalItems.storyArray.count-1
                self.navigationController?.pushViewController(nextScreen, animated: true)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    //navigate to story list
    @objc func navigateToStoryList()
    {
        let nextScreen = storyTableView()
        nextScreen.title = "Story List"
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    @objc func goingToBackEnd(){
          print("closing")
          DataControllerInstance.saveStoriesToDisk(stories: GlobalVar.GlobalItems.storyArray)
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
