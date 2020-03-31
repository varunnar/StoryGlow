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
        static var lightsOn = true
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
    let imageView = UIImageView(image: UIImage(named: "logo-1"))
    override func viewDidLoad() {
        super.viewDidLoad()
        let previousStories = DataControllerInstance.getStoriesFromDisk()
        GlobalVar.GlobalItems.storyArray = previousStories
        if (GlobalVar.tutorial.firstOpening == true){
            if (GlobalVar.tutorial.introPageFirstOpening == true){
                setupTutorial()
                GlobalVar.tutorial.introPageFirstOpening = false
            }
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(goingToBackEnd), name: UIApplication.willResignActiveNotification, object: nil)
        lightService.start() //start looking for lights
        NotificationCenter.default.addObserver(self, selector: #selector(AddedLight), name: NSNotification.Name(rawValue: "LightAdded"), object: nil) //notification for when light is added
        self.navigationController?.navigationBar.topItem?.title = "Welcome to StoryGlow" //set top title

        NotificationCenter.default.addObserver(self, selector: #selector(turnOffLights), name: NSNotification.Name(rawValue: "turnLightsOff"), object: nil)
        self.navigationController?.navigationBar.topItem?.title = "Welcome to StoryGlow" //set top title

        view.backgroundColor = .black
        view.addSubview(mainStackView)
        addStoryButton.backgroundColor = UIColor(red:0.84, green:0.36, blue:0.69, alpha:1.00)
        storyListButton.backgroundColor = UIColor(red:0.52, green:0.37, blue:0.76, alpha:1.00)
        addStoryButton.setTitle("Add Story", for: .normal)
        storyListButton.setTitle("Story List", for: .normal)
        addStoryButton.layer.cornerRadius = 10
        storyListButton.layer.cornerRadius = 10
        addStoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        storyListButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        setupImageView()
        //NEEDS CONTRAINTS

        setupStackview()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Welcome to StoryGlow"
    }
    
    func setupImageView()
    {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -30).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupTutorial(){
        let nextScreen = tutorialPageViewController()
        nextScreen.tutorialPageArrayImage = ["IntroPage","IntroPageAddStory","IntroPageStoryName","introPageSceneName","IntroPageStoryList"]
        nextScreen.tutorialPageArrayLabel = ["Welcome to Storyglow. As it's your first time let's give you a little tutorial. This is the homepage where you will start each time you start the app.", "On the welcome page one of the first things you can do is make a story. This is done by clicking the 'Add Story' button","Add a name to the story with this alert. By hitting done you will be moved to the next alert.","Finally, name the first scene of story to start the StoryGlow project. After doing this you will be navigated to the project page","From this page, you can also access your list of previous stories by clicking on the story list"]
        self.navigationController?.present(nextScreen, animated: true, completion: nil)
    }
    
    
    //function for when light is added, randomizes color in order to show user light is connected
    @objc func AddedLight(notification: Notification){
        if let light = notification.object as? Light{
            lightsStruct.lightArray.append(light)
            let color = HSBK(hue: UInt16(.random(in: 0...1) * Float(UInt16.max)), saturation: UInt16(.random(in: 0...1) * Float(UInt16.max)), brightness: UInt16(1 * Float(UInt16.max)), kelvin: 0)
            let setColor = LightSetColorCommand.create(light: light, color: color, duration: 0)
               setColor.fireAndForget()
        }
    }
    
    @objc func turnOffLights()
    {
        if lightsStruct.lightsOn == true{
            lightsStruct.lightsOn = false
            for light in lightsStruct.lightArray{
                let power = LightSetPowerCommand.create(light: light, status: false, duration: 0)
                power.fireAndForget()
            }
        }
        else{
            lightsStruct.lightsOn = true
            for light in lightsStruct.lightArray{
                let power = LightSetPowerCommand.create(light: light, status: true, duration: 0)
                power.fireAndForget()
            }
        }
    }
    
    //MARK: Setup and Constraints
    
    func setupStackview()
    {
        view.addSubview(mainStackView)
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
