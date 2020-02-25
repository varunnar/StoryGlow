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


class soundTableViewController: UIViewController, UISearchBarDelegate {
    var player: AVPlayer!
    var SoundNamesArray = [String]()
    var SoundURLArray = [String]()
    var celldata: [CellData] = [] //array of sounds
    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    
    //UI Items

    struct cells{
           static let soundCell = "SoundCell"
       }
    //MARK: table view stuff
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Sounds Stuff"
        celldata = fetchdata()
        configureTableView()
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
    }
    
//    MARK:Tableview stuff
    func configureTableView(){
        self.view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100 //control row height
        //register cells
        tableView.register(SoundCell.self, forCellReuseIdentifier: cells.soundCell)
        tableView.pin(to:view)
    }
    
    func setTableViewDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK:Search bar stuff
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //make Api call
        let SearchWord = searchBar.text!
        MakeApiCall(SearchItem: SearchWord)

    }

//    func CreateSounds(SoundURL:String){
//        let url = URL.init(string:SoundURLArray[1])
//        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
//        player = AVPlayer(playerItem: playerItem)
//        let playerLayer = AVPlayerLayer(player: player!)
//        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
//        self.view.layer.addSublayer(playerLayer)
//        player.play()
//
//    }
//
//    @objc func playSounds(){
//        self.CreateSzounds(SoundURL: self.SoundURLArray[1]) //ide
//        player.play()
//    }
    
    @objc func pauseSound(){
        player.pause()
    }
    
//   MARK: cannot search anything with spaces in the search string
    func MakeApiCall(SearchItem:String){
        self.SoundURLArray.removeAll()
        let network = Networking(baseURL: createURL(search: SearchItem, page: "1"))
        network.headerFields = ["Authorization": "Token L4bKom5YT2k8DfabolQKJ3duTAkFDIzTuZWnUzpC"]
        network.get(""){
            result in switch (result){
            case.success(let data):
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
                print("Error")
            }
        }
    }
    
    
    
    //Playing fucntion in table view
    @objc func playSound(){
        let url = URL.init(string:SoundURLArray[1])
        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    //Adding the sound to the sound board
    @objc func AddingSounds(){
        print( "Add sounds")
    }
}


//extension

extension soundTableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celldata.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells.soundCell) as! SoundCell
        cell.playButton.addTarget(self, action: #selector(playSound),for: .touchUpInside)
        cell.addButton.addTarget(self, action: #selector(AddingSounds),for: .touchUpInside)
        if SoundNamesArray.count == 0{
            return UITableViewCell()
        }else{
            cell.soundName.text = SoundNamesArray[indexPath.row]
            return cell
        }
        
    }
        
}

//instead
extension soundTableViewController{
    
    func fetchdata() -> [CellData] {
        let cellHold1 = CellData(title: "Cell1", button: UIButton())
        let cellHold2 = CellData(title: "Cell2", button: UIButton())
        let cellHold3 = CellData(title: "Cell3", button: UIButton())
        let cellHold4 = CellData(title: "Cell4", button: UIButton())
        let cellHold5 = CellData(title: "Cell5", button: UIButton())
        let cellHold6 = CellData(title: "Cell6", button: UIButton())
        let cellHold7 = CellData(title: "Cell7", button: UIButton())
        let cellHold8 = CellData(title: "Cell8", button: UIButton())
        let cellHold9 = CellData(title: "Cell9", button: UIButton())
        let cellHold10 = CellData(title: "Cell10", button: UIButton())
        return [cellHold1, cellHold2, cellHold3, cellHold4, cellHold5, cellHold6, cellHold7, cellHold8, cellHold9, cellHold10]
    }
}

