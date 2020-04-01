//
//  ViewController.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/24/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    var storyIndexRec = Int()
    var sceneIndexRec = Int()
    var buttonIndexRec = Int()
    
    //variables
    let audioSession = AVAudioSession.sharedInstance()
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    //Bool to indicate if we are currently recording
    var recording = false
    var playing = false

    var RecButton = UIButton(frame: CGRect(x: 100, y: 275, width: 200, height: 200))
    var PlayButton = UIButton(frame: CGRect(x: 100, y: 500, width: 85, height: 85))
    var SearchButton = UIButton(frame: CGRect(x: 225, y: 500, width: 85, height: 85))
    var SaveButton = UIButton(frame: CGRect(x: 100, y: 600, width: 215, height: 50))


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        if (GlobalVar.tutorial.firstOpening == true){
            if (GlobalVar.tutorial.soundPageFirstOpening == true){
                setupTutorial()
                GlobalVar.tutorial.soundPageFirstOpening = false
            }
        }
//MARK: UI FOR APP
    //Record button
        ControlRecordingButton()
        RecButton.addTarget(self, action: #selector(RecButtonAction), for: .touchUpInside)
        self.view.addSubview(RecButton)
    //Play Button
        ControlPlayButton()
        PlayButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        PlayButton.backgroundColor = UIColor(red:1.00, green:0.44, blue:0.57, alpha:1.00)

        self.view.addSubview(PlayButton)
    //Save Button
        SaveButton.setTitle("Save Sound", for: .normal)
        SaveButton.setTitleColor(UIColor.black, for: .normal)
        SaveButton.titleLabel?.numberOfLines = 0
        SaveButton.titleLabel?.textAlignment = NSTextAlignment.center
        SaveButton.backgroundColor = UIColor(red:1.00, green:0.78, blue:0.37, alpha:1.00)
        SaveButton.addTarget(self, action: #selector(saveSound), for: .touchUpInside)
        self.view.addSubview(SaveButton)
        
    //Search Button
        SearchButton.backgroundColor = UIColor(red:1.00, green:0.59, blue:0.44, alpha:1.00)
        SearchButton.setImage(UIImage(named: "search"), for: .normal)
        SearchButton.titleLabel?.textAlignment = NSTextAlignment.center
        SearchButton.titleLabel?.numberOfLines = 0
        SearchButton.addTarget(self, action: #selector(searchSound), for: .touchUpInside)
        self.view.addSubview(SearchButton)
        
        
        RecButton.layer.cornerRadius = 15
        PlayButton.layer.cornerRadius = 15
        SaveButton.layer.cornerRadius = 15
        SearchButton.layer.cornerRadius = 15

//MARK: Other Code in View Did Load
        // enable play and stop since we don't have any audio to work with on load
             //get path for the audio file
             let dirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
             let docDir = dirPath[0]
             let filename = "audio\(String(buttonIndexRec)).m4a"
             let audioFileURL = docDir.appendingPathComponent(filename)
             print("AUDIO FILE NAME: \(audioFileURL)")
             
             //configure our audioSession
             do {
                 try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .init(rawValue: 1))
             } catch {
                 print("audio session error: \(error.localizedDescription)")
             }
             
             //declare our settings in a dictionary
             let settings = [
                 AVFormatIDKey: Int(kAudioFormatMPEG4AAC), // audio codec
                 AVSampleRateKey: 1200, //sample rate in hZ
                 AVNumberOfChannelsKey: 1, //num of channels
                 AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // audio bit rate
             ]
             
             do{
                 //create our recorder instance
                 audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
                 //get it ready for recording by creating the audio file at the specified location
                 audioRecorder?.prepareToRecord()
                 print("Audio recorder ready!")
             }catch {
                 print("Audio recorder error")
         }
     }
    
    func setupTutorial(){
        let nextScreen = tutorialPageViewController()
        nextScreen.tutorialPageArrayImage = ["soundSelection","soundSelectionRecord","soundSelectionPlay","soundSelectionSave","soundSelectionSearch","SoundSearch","SoundSearchedPlay","SoundSearchedAdd"]
        nextScreen.tutorialPageArrayLabel = ["This is the sound selection screen. Here you can record a sound, play it and add it or you can search for a sound with our integration with freesounds.org","By clicking the record button you can record yourself making sound affects! Of course you have to allow the app to use your mic or this step will not work.","After recording the sound you can play it back using the play button.","If the sound sounds good, go ahead and save it. It'll be added to one of your sound buttons in your StoryGlow scene.","If the sound affect you need is not something you think you can record you can hit search for sound.","This is the page where you will find searched sounds. Just type in a word and we will look through freesounds.org to see if there are some sound affects you can use.","After a quick pause your potential sound affects will appear. Just hit play to sample them and find one you like.","Once you find one you like click the add button to add it to your project! A sound affect is found."]
        self.navigationController?.present(nextScreen, animated: true, completion: nil)
    }
    
//MARK:Button actions
    //load table view
    @objc func searchSound(sender: UIButton!) {
        let nextScreen = SoundTableViewController()
        nextScreen.buttonIndexSTV = buttonIndexRec
        nextScreen.sceneIndexSTV = sceneIndexRec
        nextScreen.storyIndexSTV = storyIndexRec
        nextScreen.title = "Search Sounds"
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    //save URL and sound name
    @objc func saveSound(sender: UIButton!) {
        let audioFile = (audioRecorder?.url)!
        let audioFileString = audioFile.absoluteString
        GlobalVar.GlobalItems.storyArray[storyIndexRec].sceneArray[sceneIndexRec].buttonInfo[buttonIndexRec].soundName = "Sound \(String(buttonIndexRec))"
        GlobalVar.GlobalItems.storyArray[storyIndexRec].sceneArray[sceneIndexRec].buttonInfo[buttonIndexRec].soundVal = audioFileString
        
        let vc = self.navigationController?.viewControllers.filter({$0 is PageHolder}).first as! PageHolder//is first first or last?
        vc.currentSceneIndex = sceneIndexRec
        navigationController?.popToViewController(vc, animated: true)
    }
    
    //record sounds
    @objc func RecButtonAction(sender: UIButton!) {
        if let recorder = audioRecorder {
            //check to make sure we aren't already recording
            if recorder.isRecording == false {
                //enable the stop button and start recording
                recording = true
                ControlRecordingButton()
                recorder.delegate = self
                recorder.record()
            }else{
                recording = false;
                ControlRecordingButton()
                audioRecorder?.stop()
            }
        } else {
            print("No audio recorder instance")
        }
    }
    //play sounds
    @objc func playButtonAction(sender: UIButton!) {
        if playing == false{
            playing = true
            ControlPlayButton()
        }else{
            playing = false
            ControlPlayButton()
            //it is playing
            audioPlayer?.stop()
            //reset session mode
            do{
                try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            }catch{
                print(error)
            }
        }
        if audioRecorder?.isRecording == false {
            if playing == true{
                do {
                    try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                    //set to playback mode for optimal volume
                    try audioSession.setCategory(AVAudioSession.Category.playback)
                    audioPlayer!.delegate = self
                    audioPlayer!.prepareToPlay() // preload audio
                    audioPlayer!.play() //plays audio file
                } catch {
                    print("audioPlayer error")
                }
            }
            
        }
    }
    
//control UI for record button
    func ControlRecordingButton() {
        if recording == false{
            RecButton.setImage(UIImage(named: "startRecord.png"), for: .normal)
        }else{
            RecButton.setImage(UIImage(named: "stopRecord.png"), for: .normal)
        }
    }
    //control UI for play button
    func ControlPlayButton(){
        if playing == false{
            PlayButton.setImage(UIImage(named: "play.png"), for: .normal)

        }else{
            PlayButton.setImage(UIImage(named: "pause"), for: .normal)

        }
    }

}


