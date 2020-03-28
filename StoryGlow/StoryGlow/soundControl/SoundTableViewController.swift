//
//  soundTableViewController.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/24/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit
import Networking
import AVFoundation
import AVKit


class SoundTableViewController: UIViewController, UISearchBarDelegate {
    var storyIndexSTV = Int()
    var sceneIndexSTV = Int()
    var buttonIndexSTV = Int()
    
    
    var player: AVPlayer!
    var SoundNamesArray = [String]()
    var SoundURLArray = [String]()
    
    var spinnerView: UIView?
   
    
//MARK:UI Items
    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))

    var tableView = UITableView()
    struct cells{
        static let soundCell = "SoundCell" //custom tableview cells
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
    }
    
//MARK:Setting up tableview
    func configureTableView(){
        self.view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100 //control row height
        //registering cells
        tableView.register(CustomSoundCell.self, forCellReuseIdentifier: cells.soundCell)
        tableView.pin(to:view)
    }
    
    func setTableViewDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }

//MARK:Set up Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //make Api call
        let SearchWord = searchBar.text!
        let NewSearchWord = SearchWord.replacingOccurrences(of: " ", with: "%20")

        MakeApiCall(SearchItem: NewSearchWord)

    }
    
 //MARK: Helper Functions
    func MakeApiCall(SearchItem:String){
        self.SoundURLArray.removeAll()
        self.SoundNamesArray.removeAll()
        self.showSpinner(onView: view)
        let network = Networking(baseURL: createURL(search: SearchItem, page: "1"))
        network.headerFields = ["Authorization": "Token L4bKom5YT2k8DfabolQKJ3duTAkFDIzTuZWnUzpC"]
        network.get(""){
            result in switch (result){
            case.success(let data):
                self.stopSpinner()
                let json = data.dictionaryBody
                let results = json["results"] as! NSArray
                //traversing results
                for i in results{
                    let SoundData = i as! NSDictionary //dictionary for all of our sounds in API call
                    let SoundsName = SoundData.value(forKey: "name") as! String // name of sound
                    self.SoundNamesArray.append(SoundsName)
                    let previews = SoundData.value(forKey: "previews") as! NSDictionary //dictionary of previews
                    let MP3url = previews.value(forKey: "preview-lq-mp3") as! String // get the preview low quality
                    self.SoundURLArray.append(MP3url)
                    self.tableView.reloadData()
                }
            case.failure(_):
                self.stopSpinner()
                print("Error")
            }
        }
    }
    
    
    
//MARK:Button Functions
    //playing and pausing audio
    @objc func soundActions(_ sender: UIButton){
        let buttonPostion = sender.convert(sender.bounds.origin, to: tableView) // gives position of tap
        if sender.currentImage == UIImage(named: "play.png"){ //play the audio
            sender.setImage(UIImage(named: "pause.png"), for: .normal)
            if let indexPath = tableView.indexPathForRow(at: buttonPostion) {
               let url = URL.init(string:SoundURLArray[indexPath.row])
               let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
               player = AVPlayer(playerItem: playerItem)
               let playerLayer = AVPlayerLayer(player: player!)
               playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
               self.view.layer.addSublayer(playerLayer)
               player.play()}
            }
        else{//Pause the audio
            player.pause()
            sender.setImage(UIImage(named: "play.png"), for: .normal)
        }
    }
    
    //Adding the sound to the sound board
    @objc func addingSounds(_ sender: UIButton){
        let buttonPostion = sender.convert(sender.bounds.origin, to: tableView) // gives position of tap
        if let indexPath = tableView.indexPathForRow(at: buttonPostion) {
            let soundURLString = SoundURLArray[indexPath.row]
            let soundNameString = SoundNamesArray[indexPath.row]
        GlobalVar.GlobalItems.storyArray[storyIndexSTV].sceneArray[sceneIndexSTV].buttonInfo[buttonIndexSTV].soundName = soundNameString
            print(soundURLString)
            print(sceneIndexSTV)
            print(buttonIndexSTV)
        GlobalVar.GlobalItems.storyArray[storyIndexSTV].sceneArray[sceneIndexSTV].buttonInfo[buttonIndexSTV].soundVal = soundURLString
            let vc = self.navigationController?.viewControllers.filter({$0 is PageHolder}).first //is first first or last?
            navigationController?.popToViewController(vc!, animated: true)
        
        }

       

    }
}


//MARK: Extensions
extension SoundTableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SoundNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells.soundCell) as! CustomSoundCell
        cell.actionButton.addTarget(self, action: #selector(soundActions),for: .touchUpInside)
        cell.addButton.addTarget(self, action: #selector(addingSounds),for: .touchUpInside)
        if SoundNamesArray.count == 0{
            return UITableViewCell()
        }else{
            cell.soundName.text = SoundNamesArray[indexPath.row]
            return cell
        }
    }
        
}

extension SoundTableViewController{
    func showSpinner(onView: UIView)
    {
        print("finding sounds")
        let spinView = UIView.init(frame: onView.bounds)
        spinView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let spinner = UIActivityIndicatorView.init(style: .medium)
        spinner.startAnimating()
        spinner.center = onView.center
        
        DispatchQueue.main.async {
            print("in dispatch queue")
            spinView.addSubview(spinner)
            onView.addSubview(spinView)
        }
        spinnerView = spinView
    }
    
    func stopSpinner(){
        DispatchQueue.main.async {
            self.spinnerView?.removeFromSuperview()
            self.spinnerView = nil
        }
    }
}

