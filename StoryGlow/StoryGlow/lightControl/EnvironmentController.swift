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
    
    var storyIndex = Int() //index that holds the current story number
    var sceneIndex = Int() //index that holds the scene number within that story
    var playerMod = [playerModel](repeating: playerModel(), count: 6) //each environmentController has an array of players so that we can
    var audioPlayer: AVAudioPlayer?
    let audioSession = AVAudioSession.sharedInstance() //used inorder to play sound at setup volume

    var playingArray = [Bool](repeating: Bool(false), count: 6) //array of booleans used to determining pausing and playing
    var soundButtonArray = [UIButton]() //Array of 6 buttons
    
    //UI Items
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
    let startTextField =  UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 30))
    let endTextField =  UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 30))

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].sceneName
        view.backgroundColor = .white
        
        editTextConfig()
        
        //setting up Segmented Control
        SegmentedControlConfig()
        
        //setting up the stackviews and images
        SetupStackView1()
        SetupStackView2()
        SoundButtonSyncing()
        SetupColorWheel()
        
        //Adding gestures to the image to allow color selection
        let imageClickedGesture = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        let imageDragGesture = UIPanGestureRecognizer(target: self, action: #selector(imageTap))
        ColorWheelView.addGestureRecognizer(imageClickedGesture)
        ColorWheelView.addGestureRecognizer(imageDragGesture)
        ColorWheelView.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    //this viewdidappear is used to add colors and sounds after swiping data model
    override func viewDidAppear(_ animated: Bool) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        let scene = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex]
        //get color value from data model. Color is initialized to white
        let previousColor = UIColor(red: scene.red, green: scene.green, blue: scene.blue, alpha: scene.alpha)
        previousColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) //setup colors as HSBK colors and set light colors
        let color = HSBK(hue: UInt16(65535*hue), saturation: UInt16(65535*saturation), brightness: UInt16(65535*brightness), kelvin: 0)
        for i in IntroPage.lightsStruct.lightArray{
            let setColor = LightSetColorCommand.create(light: i, color: color, duration: 0)
            setColor.fireAndForget()
        }
        
        //readding sounds to buttons on swiping
        for n in 0...5{
            soundButtonArray[n].setTitle(GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[n].soundName, for: .normal)
            if (GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[n].soundName != "")
            {
                soundButtonArray[n].interactions = []
                let interaction = UIContextMenuInteraction(delegate: self)
                soundButtonArray[n].addInteraction(interaction)
            }
        }
        
        //check if story is in present mode or not on swiping
        if PageHolder.editModeStruct.editMode == false{
            startTextField.borderStyle = UITextField.BorderStyle.none
            endTextField.borderStyle = UITextField.BorderStyle.none
            startTextField.text = "Start: " + GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].startText
            endTextField.text = "Stop: " + GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].endText
            startTextField.isUserInteractionEnabled = false
            endTextField.isUserInteractionEnabled = false
            for i in 0...5{
                if GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[i].soundName == ""{
                    soundButtonArray[i].isHidden = true
                }
            }
            SegmentedControl.selectedSegmentIndex = 1
        }else{
            startTextField.borderStyle = UITextField.BorderStyle.line
            endTextField.borderStyle = UITextField.BorderStyle.line
            startTextField.text = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].startText
            endTextField.text = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].endText
            startTextField.isUserInteractionEnabled = true
            endTextField.isUserInteractionEnabled = true
            for i in 0...5{
                soundButtonArray[i].isHidden = false
            }
            SegmentedControl.selectedSegmentIndex = 0
        }
        
    }
    
    //adds soundbuttons to sound array, give them accessibilityIndentifiers for contextMenus and add target functionality
    func SoundButtonSyncing()
    {
        soundButtonArray.append(SoundButton1)
        soundButtonArray.append(SoundButton2)
        soundButtonArray.append(SoundButton3)
        soundButtonArray.append(SoundButton4)
        soundButtonArray.append(SoundButton5)
        soundButtonArray.append(SoundButton6)
        /*SoundButton1.accessibilityIdentifier = "soundButton1"
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
        SoundButton6.addTarget(self, action: #selector(AddSounds(sender:)), for: .touchUpInside)*/
        for i in 0...5{
            soundButtonArray[i].layer.borderColor = UIColor.gray.cgColor
            soundButtonArray[i].layer.borderWidth = 2
            soundButtonArray[i].accessibilityIdentifier = "soundButton\(i+1)"
            soundButtonArray[i].addTarget(self, action: #selector(AddSounds(sender:)), for: .touchUpInside)
        }
    }
    
    //MARK: Button Control
    //Navigating to sound screen and getting button info
    @objc func AddSounds(sender: UIButton)
    {
        //this is also where we will need to sort out if we are adding or playing the item
        if let buttonIndex = self.soundButtonArray.firstIndex(of: sender)
        {
            //if we are in edit mode
            if PageHolder.editModeStruct.editMode == true{
               let nextScreen = RecordAudioController()//change later
               nextScreen.buttonIndexRec = buttonIndex
               nextScreen.sceneIndexRec = sceneIndex
               nextScreen.storyIndexRec = storyIndex
               nextScreen.title = "Add a Sound Effect"
               navigationController?.pushViewController(nextScreen, animated: true)
            //if we are in present mode
            }else{
            //play sounds
                playSounds(buttonIndex: buttonIndex)
            }
        }
    }
    
    //function that actually plays sound
    func playSounds(buttonIndex:Int)
    {
        //If audio string is an url from freesound
        if GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[buttonIndex].soundVal.contains("https") == true {
            //If player boolean is true and player is playing (boolean may not be needed)
            if (playingArray[buttonIndex] == true && playerMod[buttonIndex].player.timeControlStatus == .playing){
                playerMod[buttonIndex].player.pause()
                playingArray[buttonIndex] = false
            }else{
                let url = URL.init(string:GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[buttonIndex].soundVal) //convert string from data model to url
                let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
                playerMod[buttonIndex].player = AVPlayer(playerItem: playerItem)
                playerMod[buttonIndex].player.volume = 1.0
                let playerLayer = AVPlayerLayer(player: playerMod[buttonIndex].player)
                playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
                self.view.layer.addSublayer(playerLayer)
                playingArray[buttonIndex] = true
                playerMod[buttonIndex].player.play()
            }
        }
        //if audio string is a url we recorded
        else{
            //If player boolean is true and player is playing (boolean may not be needed)
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
    
    //text change function
    @objc func textFieldEditingDidChange(){
        GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].startText = startTextField.text!
        GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].endText = endTextField.text!
    }
    
    
    //MARK: Segmented Control
    //Control segmented control
    @objc func indexChanged(_ sender: UISegmentedControl) {
        let EditModeNotification = Notification.Name("editMode")
        NotificationCenter.default.post(Notification(name: EditModeNotification))
        //If switched to presentation mode
        if sender.selectedSegmentIndex == 1{
            startTextField.borderStyle = UITextField.BorderStyle.none
            endTextField.borderStyle = UITextField.BorderStyle.none
            startTextField.text = "Start: " + GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].startText
            endTextField.text = "Stop: " + GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].endText
            startTextField.isUserInteractionEnabled = false
            endTextField.isUserInteractionEnabled = false
            for i in 0...5
                {
                if GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[i].soundName == ""{
                    soundButtonArray[i].isHidden = true //hide unused buttons
                }
                soundButtonArray[i].interactions = [] //remove contextMenu interactions
            }
        }
        // if in edit mode load all buttons
        else{
            startTextField.borderStyle = UITextField.BorderStyle.line
            endTextField.borderStyle = UITextField.BorderStyle.line
            startTextField.text = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].startText
            endTextField.text = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].endText
            startTextField.isUserInteractionEnabled = true
            endTextField.isUserInteractionEnabled = true
            for i in 0...5{
                soundButtonArray[i].isHidden = false //show buttons
                if (GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].buttonInfo[i].soundName != ""){
                    let interaction = UIContextMenuInteraction(delegate: self)
                    soundButtonArray[i].addInteraction(interaction) //add interactions to buttons that are populated
                }
            }
        }
        
    }
    
    
    
    //MARK:Constraints and Setup
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
        SegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        SegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true

    }
    
    //Addint the edit texts
    func editTextConfig(){
        startTextField.borderStyle = UITextField.BorderStyle.line
        startTextField.backgroundColor = UIColor.white
        startTextField.placeholder = "Start"
        startTextField.font = UIFont.systemFont(ofSize: 15)
        startTextField.autocorrectionType = UITextAutocorrectionType.no
        startTextField.keyboardType = UIKeyboardType.default
        startTextField.returnKeyType = UIReturnKeyType.done
        startTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        startTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        startTextField.delegate = self as? UITextFieldDelegate
        startTextField.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControl.Event.editingChanged)
        self.view.addSubview(startTextField)
        
        
        endTextField.borderStyle = UITextField.BorderStyle.line
        endTextField.backgroundColor = UIColor.white
        endTextField.placeholder = "Stop"
        endTextField.font = UIFont.systemFont(ofSize: 15)
        endTextField.autocorrectionType = UITextAutocorrectionType.no
        endTextField.keyboardType = UIKeyboardType.default
        endTextField.returnKeyType = UIReturnKeyType.done
        endTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        endTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        endTextField.delegate = self as? UITextFieldDelegate
        endTextField.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControl.Event.editingChanged)
        self.view.addSubview(endTextField)

        endTextField.translatesAutoresizingMaskIntoConstraints = false
        endTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        endTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        endTextField.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        
        startTextField.translatesAutoresizingMaskIntoConstraints = false
        startTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        startTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        startTextField.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true

    }
    
     //setting up buttons and adding them to stackview1
    func SetupStackView1()
    {
        SoundButton1.backgroundColor = .gray
        SoundButton2.backgroundColor = .gray
        SoundButton3.backgroundColor = .gray
        SoundButton1.layer.cornerRadius = 10
        SoundButton2.layer.cornerRadius = 10
        SoundButton3.layer.cornerRadius = 10
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
    
    //configuring stackview1's constraints
    func StackViewConfig1()
    {
        StackView1.translatesAutoresizingMaskIntoConstraints = false
        StackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        StackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        StackView1.heightAnchor.constraint(equalToConstant: 80).isActive = true
        StackView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 170).isActive = true
        
    }
    
    //setting up buttons and adding them to stackview2
    func SetupStackView2()
    {
        SoundButton4.backgroundColor = .gray
        SoundButton5.backgroundColor = .gray
        SoundButton6.backgroundColor = .gray
        SoundButton4.layer.cornerRadius = 10
        SoundButton5.layer.cornerRadius = 10
        SoundButton6.layer.cornerRadius = 10
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
        colorwheelConfig()
    }
    
    //Setting up the Colorwheel image and adding Constraints
    func colorwheelConfig()
    {
        ColorWheelView.translatesAutoresizingMaskIntoConstraints = false
        ColorWheelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ColorWheelView.topAnchor.constraint(equalTo: StackView2.bottomAnchor, constant: 50).isActive = true
        //making sure UIImageView is the same size as the image so the CGimage pixels line up with the UIImage pixels
        ColorWheelView.widthAnchor.constraint(equalToConstant: ColorWheel.size.width).isActive = true
        ColorWheelView.heightAnchor.constraint(equalToConstant: ColorWheel.size.height).isActive = true
    }
    
    //MARK: Image
    //Checks if image is clicked, check the color of the image at the point, change the color of the button and the color of every light. May not be needed with longtap gesture recognizer as well
    @objc func imageTap(recognizer: UITapGestureRecognizer)
    {
        let point = recognizer.location(in: ColorWheelView)
        let point2 = recognizer.location(in: view)
        let centerPoint = ColorWheelView.center
        let distance = (pow(centerPoint.x-point2.x, 2) + pow(centerPoint.y-point2.y,2)).squareRoot()
        if (distance>ColorWheelView.frame.width-3){
            print("out of circle")
        }
        else{
            let x = Int(point.x)
            let y = Int(point.y)
            
            let RGBcolor = ColorWheel[x,y]
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            if let realColor = RGBcolor{
                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0
                var alpha: CGFloat = 0
                realColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].red = red
                GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].blue = blue
                GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].green = green
                GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sceneIndex].alpha = alpha
                //converting color from RGB to HSB
                realColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
                //maybe get saturation and brightness
                //Setting light color
                let color = HSBK(hue: UInt16(65535*hue), saturation: UInt16(65535*saturation), brightness: UInt16(65535*brightness), kelvin: 0)
                
                //Iterating through all lights and changing the color
                //colorView.backgroundColor = realColor
                for j in soundButtonArray{
                    j.backgroundColor = realColor
                }
                for i in IntroPage.lightsStruct.lightArray{
                    let setColor = LightSetColorCommand.create(light: i, color: color, duration: 0)
                    setColor.fireAndForget()
                }
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

//The setup of the context menu, choosing buttons
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
    
    //Building context menu
    func makeContextMenu(interact: UIContextMenuInteraction) -> UIMenu
    {
        var buttonIndex = 0
        for i in 0...self.soundButtonArray.count-1{
            if (interact.view?.accessibilityIdentifier == self.soundButtonArray[i].accessibilityIdentifier){
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
