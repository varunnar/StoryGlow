//
//  EnvironmentController.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 1/30/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import RxLifxApi
import RxLifx
import LifxDomain
import AVFoundation


class EnvironmentController: UIViewController, AVAudioPlayerDelegate{
    
    var colorSelected = false //Color preselected for this scene
    var storyIndex = Int()
    var sceneIndex = Int()
    
    var playerMod = [playerModel](repeating: playerModel(), count: 6)
    var audioPlayer: AVAudioPlayer?
    let audioSession = AVAudioSession.sharedInstance()
    //var player = AVPlayer(url: URL(string: "https://freesound.org/data/previews/392/392617_7383104-lq.mp3")!)

    var playingArray = [Bool](repeating: Bool(false), count: 6)
    var soundButtonArray = [UIButton]() //Array of 6 buttons
    var colorView = UIView() //band color
    var SoundButton1 = UIButton()
    var SoundButton2 = UIButton()
    var SoundButton3 = UIButton()
    var SoundButton4 = UIButton()
    var SoundButton5 = UIButton()
    var SoundButton6 = UIButton()
    let SegmentedControl = UISegmentedControl(items : ["Edit Mode" , "Presentation Mode"])
    var StackView1 = UIStackView()
    var StackView2 = UIStackView()
    var ColorWheelView = UIImageView()
    var ColorWheel = UIImage()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.count == sceneIndex{
            let Scene = GlobalVar.Scenes(sceneName: "newScene", colorVal: UIColor()) //define a new scene
            GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.append(Scene)
        }
        view.backgroundColor = .white
        
        //setting up Segmented Control
        SegmentedControlConfig()
        
        //setting up the stackviews and images
        SetupStackView1()
        SetupStackView2()
        SetupColorWheel()
        
        //Adding gestures to the image to allow color selection
        let imageClickedGesture = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        let imageDragGesture = UIPanGestureRecognizer(target: self, action: #selector(imageTap))
        ColorWheelView.addGestureRecognizer(imageClickedGesture)
        ColorWheelView.addGestureRecognizer(imageDragGesture)
        ColorWheelView.isUserInteractionEnabled = true
        SoundButtonSyncing()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) { //readding light color when swiping back
        self.navigationController?.navigationBar.topItem?.title = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].sceneName
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
        let previousColor = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].colorVal
                previousColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
                let color = HSBK(hue: UInt16(65535*hue), saturation: UInt16(65535*saturation), brightness: UInt16(65535*brightness), kelvin: 0)
                for i in IntroPage.lightsStruct.lightArray{
                    let setColor = LightSetColorCommand.create(light: i, color: color, duration: 0)
                    setColor.fireAndForget()
            }
        for n in 0...5{            soundButtonArray[n].setTitle(GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[n].soundName, for: .normal)
            if (GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[n].soundName != "")
            {
                print("adding interaction")
                soundButtonArray[n].interactions = []
                let interaction = UIContextMenuInteraction(delegate: self)
                soundButtonArray[n].addInteraction(interaction)
            }
        }
        
        //when adding a new scene control what is shown on the segmented control
        if PageHolder.editModeStruct.editMode == false{
            for i in 0...5{
                if GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[i].soundName == ""{
                    soundButtonArray[i].isHidden = true
                }
            }
            SegmentedControl.selectedSegmentIndex = 1
        }else{
            for i in 0...5{
                soundButtonArray[i].isHidden = false
            }
            SegmentedControl.selectedSegmentIndex = 0
        }
        
    }
    
    func SoundButtonSyncing()
    {
        soundButtonArray.append(SoundButton1)
        soundButtonArray.append(SoundButton2)
        soundButtonArray.append(SoundButton3)
        soundButtonArray.append(SoundButton4)
        soundButtonArray.append(SoundButton5)
        soundButtonArray.append(SoundButton6)
        SoundButton1.accessibilityIdentifier = "soundButton1"
        SoundButton2.accessibilityIdentifier = "soundButton2"
        SoundButton3.accessibilityIdentifier = "soundButton3"
        SoundButton4.accessibilityIdentifier = "soundButton4"
        SoundButton5.accessibilityIdentifier = "soundButton5"
        SoundButton6.accessibilityIdentifier = "soundButton6"
        SoundButton1.addTarget(self, action: #selector(AddSounds(sender:)), for: .touchUpInside)
        SoundButton2.addTarget(self, action: #selector(AddSounds(sender:)), for: .touchUpInside)
        SoundButton3.addTarget(self, action: #selector(AddSounds(sender:)), for: .touchUpInside)
        SoundButton4.addTarget(self, action: #selector(AddSounds(sender:)), for: .touchUpInside)
        SoundButton5.addTarget(self, action: #selector(AddSounds(sender:)), for: .touchUpInside)
        SoundButton6.addTarget(self, action: #selector(AddSounds(sender:)), for: .touchUpInside)
    }
    
    //Navigating to sound screen and getting button info
    @objc func AddSounds(sender: UIButton)
    {//this is also where we will need to sort out if we are adding or playing the item
        if let buttonIndex = self.soundButtonArray.firstIndex(of: sender)
        {
            if PageHolder.editModeStruct.editMode == true{
               let nextScreen = RecordAudioController()//change later
               nextScreen.buttonIndexRec = buttonIndex
               nextScreen.sceneIndexRec = sceneIndex
               nextScreen.storyIndexRec = storyIndex
               nextScreen.title = "Add a Sound Effect"
               navigationController?.pushViewController(nextScreen, animated: true)
            }else{
            //play sounds
                playSounds(buttonIndex: buttonIndex)
            }
        }
    }
    
    func playSounds(buttonIndex:Int)
    {
        if GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[buttonIndex].soundVal.contains("https") == true {
            if (playingArray[buttonIndex] == true && playerMod[buttonIndex].player.timeControlStatus == .playing){
                print("pause")
                print(playingArray[buttonIndex])
                print(buttonIndex)
                playerMod[buttonIndex].player.pause()
                playingArray[buttonIndex] = false
            }else{
                print("play")
                print(playingArray[buttonIndex])
                print(buttonIndex)
                print(playerMod[buttonIndex].player.rate)
                let url = URL.init(string:GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[buttonIndex].soundVal)
                let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
                playerMod[buttonIndex].player = AVPlayer(playerItem: playerItem)
                playerMod[buttonIndex].player.volume = 1.0
                let playerLayer = AVPlayerLayer(player: playerMod[buttonIndex].player)
                playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
                self.view.layer.addSublayer(playerLayer)
                playingArray[buttonIndex] = true
                playerMod[buttonIndex].player.play()
            }
        } else{
            if (playingArray[buttonIndex]==true && audioPlayer?.isPlaying == true){
                audioPlayer?.stop()
            }
            else{
                playingArray[buttonIndex] = true
                let soundUrl = URL(string: GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[buttonIndex].soundVal)
                do {
                    try audioPlayer = AVAudioPlayer(contentsOf: soundUrl!)
                    //set to playback mode for optimal volume
                    try audioSession.setCategory(AVAudioSession.Category.playback)
                    audioPlayer!.delegate = self
                    audioPlayer!.prepareToPlay() // preload audio
                    audioPlayer!.volume = 1.0
                    audioPlayer!.play() //plays audio file
                } catch {
                    print("audioPlayer error")
                }
            }
        }
    }
    
    
    
    
    //Control segmented control
    @objc func indexChanged(_ sender: UISegmentedControl) {
        let EditModeNotification = Notification.Name("editMode")
        NotificationCenter.default.post(Notification(name: EditModeNotification))
        //Take out buttons
        if sender.selectedSegmentIndex == 1{
            for i in 0...5{
                if GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[i].soundName == ""{
                    soundButtonArray[i].isHidden = true
                }
                soundButtonArray[i].interactions = []
            }
        }else{
            for i in 0...5{
                soundButtonArray[i].isHidden = false
                if (GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[i].soundName != ""){
                    let interaction = UIContextMenuInteraction(delegate: self)
                    soundButtonArray[i].addInteraction(interaction)
                }
            }
        }
        
    }
    
    
    
    //MARK:Constraints
     //setting up buttons and adding them to stackview1
    func SetupStackView1()
    {
        SoundButton1.backgroundColor = .gray
        SoundButton2.backgroundColor = .gray
        SoundButton3.backgroundColor = .gray
        view.addSubview(StackView1)
        StackView1.addArrangedSubview(SoundButton1)
        StackView1.addArrangedSubview(SoundButton2)
        StackView1.addArrangedSubview(SoundButton3)
        StackView1.axis = .horizontal
        StackView1.alignment = .fill
        StackView1.spacing = 40
        StackView1.distribution = .fillEqually
        StackViewConfig1()
    }
    //configure segmented Control
    func SegmentedControlConfig(){
        SegmentedControl.center = self.view.center
        SegmentedControl.selectedSegmentIndex = 0
        SegmentedControl.addTarget(self, action: #selector(EnvironmentController.indexChanged(_:)), for: .valueChanged)

        SegmentedControl.layer.cornerRadius = 5.0
        SegmentedControl.backgroundColor = .orange
        SegmentedControl.tintColor = .yellow

        self.view.addSubview(SegmentedControl)
        SegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        SegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        SegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        SegmentedControl.heightAnchor.constraint(equalToConstant: 80).isActive = true
        SegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true

    }
    
    //configuring stackview1's constraints
    func StackViewConfig1()
    {
        StackView1.translatesAutoresizingMaskIntoConstraints = false
        StackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        StackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        StackView1.heightAnchor.constraint(equalToConstant: 80).isActive = true
        StackView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
    }
    
    //setting up buttons and adding them to stackview2
    func SetupStackView2()
    {
        SoundButton4.backgroundColor = .gray
        SoundButton5.backgroundColor = .gray
        SoundButton6.backgroundColor = .gray
        view.addSubview(StackView2)
        StackView2.addArrangedSubview(SoundButton4)
        StackView2.addArrangedSubview(SoundButton5)
        StackView2.addArrangedSubview(SoundButton6)
        StackView2.axis = .horizontal
        StackView2.alignment = .fill
        StackView2.spacing = 40
        StackView2.distribution = .fillEqually
        StackViewConfig2()
    }
    
    
    func StackViewConfig2()
    {
        StackView2.translatesAutoresizingMaskIntoConstraints = false
        StackView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        StackView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        StackView2.heightAnchor.constraint(equalToConstant: 80).isActive = true
        StackView2.topAnchor.constraint(equalTo: StackView1.bottomAnchor, constant: 20).isActive = true
    }
    //configuring stackview2's constraints
    func SetupColorWheel()
    {
        ColorWheel = UIImage(named: "colorwheel2")!
        ColorWheelView = UIImageView(image: ColorWheel)
        ColorWheelView.layer.cornerRadius = ColorWheelView.frame.width/2
        ColorWheelView.clipsToBounds = true
        view.addSubview(ColorWheelView)
        view.addSubview(colorView)
        colorwheelConfig()
    }
    
    //Setting up the Colorwheel image and adding Constraints
    func colorwheelConfig()
    {
        ColorWheelView.translatesAutoresizingMaskIntoConstraints = false
        ColorWheelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ColorWheelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        //making sure UIImageView is the same size as the image so the CGimage pixels line up with the UIImage pixels
        ColorWheelView.widthAnchor.constraint(equalToConstant: ColorWheel.size.width).isActive = true
        ColorWheelView.heightAnchor.constraint(equalToConstant: ColorWheel.size.height).isActive = true
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.borderColor = UIColor.gray.cgColor
        colorView.layer.borderWidth = 2
        colorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        colorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //colorView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        colorView.topAnchor.constraint(equalTo: StackView2.bottomAnchor, constant: 20).isActive = true
        colorView.bottomAnchor.constraint(equalTo: ColorWheelView.topAnchor, constant:-20).isActive = true
    }
    
    //Checks if image is clicked, check the color of the image at the point, change the color of the button and the color of every light. May not be needed with longtap gesture recognizer as well
    @objc func imageTap(recognizer: UITapGestureRecognizer)
    {
        print("tapped")
        let point = recognizer.location(in: ColorWheelView)
        let x = Int(point.x)
        let y = Int(point.y)
        
        let RGBcolor = ColorWheel[x,y]
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        if let realColor = RGBcolor{
            colorSelected = true
            GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].colorVal = realColor
            print(GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].colorVal)
            //converting color from RGB to HSB
            realColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
            //Setting light color
            let color = HSBK(hue: UInt16(65535*hue), saturation: UInt16(65535*saturation), brightness: UInt16(65535*brightness), kelvin: 0)
            
            //Iterating through all lights and changing the color
            colorView.backgroundColor = realColor
            for i in IntroPage.lightsStruct.lightArray{
                let setColor = LightSetColorCommand.create(light: i, color: color, duration: 0)
                setColor.fireAndForget()
            }
        }
    }
    
}

//MARK:Extensions
//This extension gets us the pixel information of the CGimage and converts it into an RGB UIColor
extension UIImage {
    subscript(x: Int, y: Int)-> UIColor?{
        //makes sure that our point is within the range of the image
        guard x>=0 && x<Int(size.width) && y>=0 && y<Int(size.height),
            //converts cgimage data into data for each byte
            let cg = cgImage,
            let provider = cg.dataProvider,
            let providedData = provider.data,
            let pureData = CFDataGetBytePtr(providedData) else{
                return nil
        }
        //converts data into RGBA
        let componentNum = 4
        let pixelData = ((Int(size.width)*y)+x) * componentNum
        let r = CGFloat(pureData[pixelData]) / 255.0
        let g = CGFloat(pureData[pixelData + 1]) / 255.0
        let b = CGFloat(pureData[pixelData + 2]) / 255.0
        let a = CGFloat(pureData[pixelData + 3]) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: a)
            
    }
}

extension EnvironmentController: UIContextMenuInteractionDelegate{
    func contextMenuInteraction(
      _ interaction: UIContextMenuInteraction,
      configurationForMenuAtLocation location: CGPoint)
        -> UIContextMenuConfiguration? {
      return UIContextMenuConfiguration(
        identifier: nil,
        previewProvider: nil,
        actionProvider: { suggestedActions in
            return self.makeContextMenu(interact: interaction)
      })
    }
    
    func makeContextMenu(interact: UIContextMenuInteraction) -> UIMenu
    {
        var buttonIndex = 0
        for i in 0...self.soundButtonArray.count-1{
            if (interact.view?.accessibilityIdentifier == self.soundButtonArray[i].accessibilityIdentifier){
                print(interact.view?.accessibilityIdentifier)
                buttonIndex = i
            }
        }
        let rename = UIAction(title: "rename sound", image: UIImage(systemName: "pencil")){ action in
            let alert = UIAlertController(title: "Choose sound name", message: "Rename your sound", preferredStyle: .alert)
            alert.addTextField()
            let Done = UIAlertAction(title: "Done", style: .default, handler: {_ in
                let answer = alert.textFields![0].text
                if (answer != ""){
                    GlobalVar.GlobalItems.storyArray[self.storyIndex].sceneArray[self.sceneIndex].buttonInfo[buttonIndex].soundName = answer!
                    self.soundButtonArray[buttonIndex].setTitle(answer, for: .normal)
                    
                }else{
                    alert.message = "please make a valid story name"
                }
            })
            alert.addAction(Done)
            self.present(alert,animated: true,completion: nil)
        }
        let delete = UIAction(title: "delete sound", image: UIImage(systemName: "trash")){ action in
            GlobalVar.GlobalItems.storyArray[self.storyIndex].sceneArray[self.sceneIndex].buttonInfo[buttonIndex].soundName = ""
            GlobalVar.GlobalItems.storyArray[self.storyIndex].sceneArray[self.sceneIndex].buttonInfo[buttonIndex].soundVal = ""
            self.soundButtonArray[buttonIndex].interactions = []
            self.soundButtonArray[buttonIndex].setTitle("", for: .normal)
        }
        let edit = UIMenu(title: "Edit...", children: [rename, delete])
        let play = UIAction(title: "play", image: UIImage(systemName: "play")){ action in
            self.playSounds(buttonIndex: buttonIndex)
        }
        return UIMenu(title: "Options", children: [edit, play])
    }
}
