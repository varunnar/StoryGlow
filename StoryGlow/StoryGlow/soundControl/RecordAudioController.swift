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

    var RecButton = UIButton(frame: CGRect(x: 100, y: 300, width: 200, height: 50))
    var PlayButton = UIButton(frame: CGRect(x: 100, y: 400, width: 200, height: 50))
    var SaveButton = UIButton(frame: CGRect(x: 100, y: 500, width: 200, height: 50))
    var SearchButton = UIButton(frame: CGRect(x: 100, y: 600, width: 200, height: 50))


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//MARK: UI FOR APP
    //Record button
        ControlRecordingButton()
        RecButton.addTarget(self, action: #selector(RecButtonAction), for: .touchUpInside)
        self.view.addSubview(RecButton)
    //Play Button
        PlayButton.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        ControlPlayButton()
        PlayButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        self.view.addSubview(PlayButton)
    //Save Button
        SaveButton.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.3, blue: 0.5, alpha: 0.4)
        SaveButton.setTitle("Save Sound", for: .normal)
        SaveButton.addTarget(self, action: #selector(saveSound), for: .touchUpInside)
        self.view.addSubview(SaveButton)
        
    //Search Button
        SearchButton.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.3, blue: 0.5, alpha: 0.4)
        SearchButton.setTitle("Search for Sound", for: .normal)
        SearchButton.addTarget(self, action: #selector(searchSound), for: .touchUpInside)
        self.view.addSubview(SearchButton)
        
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
        
        let vc = self.navigationController?.viewControllers.filter({$0 is PageHolder}).first //is first first or last?
        navigationController?.popToViewController(vc!, animated: true)
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
            RecButton.setTitle("Start Recording", for: .normal)
            RecButton.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0)
        }else{
            RecButton.setTitle("Stop Recording", for: .normal)
            RecButton.backgroundColor = UIColor(displayP3Red: 0.7, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
    //control UI for play button
    func ControlPlayButton(){
        if playing == false{
            PlayButton.setTitle("Play Sound", for: .normal)
        }else{
            PlayButton.setTitle("Pause Sound", for: .normal)
        }
    }

}


