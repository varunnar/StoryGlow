//
//  storyTableView.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/1/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class storyTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let tableview: UITableView = {
        let StoryTableView = UITableView()
        StoryTableView.backgroundColor = UIColor.black
        StoryTableView.translatesAutoresizingMaskIntoConstraints = false
        StoryTableView.separatorColor = UIColor.black
        return StoryTableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        //if (GlobalVar.GlobalItems.firstOpening == true){
            setupTutorial()
        //}
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    func setupTutorial(){
        let nextScreen = tutorialPageViewController()
        nextScreen.tutorialPageArrayImage = ["StoryTable","StoryTableAddStory","storyTableOpenStory","StoryTableDeleteStory"]
        nextScreen.tutorialPageArrayLabel = ["In the Story List you can view the stories that you have already created, created new stories, navigate into stories and delete stories.", "By clicking the add button in the top right corner you can create a new story. This process closely resembles adding a story from the welcome page, though you will not be immediately navigated in. That way you can setup multiple stories at once.","Clicking on a story will allow you to navigate into the story and view the scene table for that story.","By swiping to the left on a story you can delete a story. However, at least one story must always be present within the storyglow table."]
        self.navigationController?.present(nextScreen, animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(storyCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVar.GlobalItems.storyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! storyCell
        if (GlobalVar.GlobalItems.storyArray.count != 0){
            cell.storyLabel.text = GlobalVar.GlobalItems.storyArray[indexPath.row].storyName
            cell.backgroundColor = UIColor.black
            let strIndexPath = String(indexPath.row + 1)
            let test = strIndexPath.last!
            switch test {
                case "1":
                    cell.cellView.backgroundColor = UIColor(red:0.52, green:0.37, blue:0.76, alpha:1.00)
                case "2":
                    cell.cellView.backgroundColor = UIColor(red:0.84, green:0.36, blue:0.69, alpha:1.00)
                case "3":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.44, blue:0.57, alpha:1.00)
                case "4":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.59, blue:0.44, alpha:1.00)
                case "5":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.78, blue:0.37, alpha:1.00)
                case "6":
                    cell.cellView.backgroundColor = UIColor(red:0.52, green:0.37, blue:0.76, alpha:1.00)
                case "7":
                    cell.cellView.backgroundColor = UIColor(red:0.84, green:0.36, blue:0.69, alpha:1.00)
                case "8":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.44, blue:0.57, alpha:1.00)
                case "9":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.59, blue:0.44, alpha:1.00)
                case "0":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.78, blue:0.37, alpha:1.00)

                default:
                    cell.cellView.backgroundColor = UIColor.orange
            
            }
        }else{
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete && GlobalVar.GlobalItems.storyArray.count > 1{
            GlobalVar.GlobalItems.storyArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            tableView.reloadData()

          }else{
               let alertConroller = UIAlertController(title: "WARNING", message: "You cannot delete this story becuase it is the last one. Please add another story.", preferredStyle: .alert)
               let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               alertConroller.addAction(alertAction)
               present(alertConroller,animated:true, completion: nil)
        }
    }

    //Function that runs when user clicks the tab button in the top right corner. Creates an new story and prompts user through alerts
    @objc func addTapped()
    {
        let alert = UIAlertController(title: "Story name", message: "What is the name of your story?", preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Next", style: .default, handler: { [unowned alert] _ in
            let answer = alert.textFields![0].text
            if (answer != ""){
                self.SceneNameAlert(storyName: answer!)
            }else{
                alert.message = "please make a valid story name"
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    //this function is run after the user creates their story and names it. A second alert is presented prompting the user to add the name of their story
    func SceneNameAlert(storyName: String)
    {
        let alert = UIAlertController(title: "Scene name", message: "What is the name of your first scene?", preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Done", style: .default, handler: { [unowned alert] _ in
            let answer = alert.textFields![0].text
            if (answer != ""){
                var story = GlobalVar.Story(storyName: storyName)
                let scene = GlobalVar.Scenes(sceneName: answer!)
                story.sceneArray.append(scene)
                GlobalVar.GlobalItems.storyArray.append(story)
                self.tableview.reloadData()
            }
            else{
                alert.message = "Please make a valid scene name"
            }

        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextScreen = environmentTableView()
        nextScreen.title = GlobalVar.GlobalItems.storyArray[indexPath.row].storyName
        nextScreen.storyIndex = indexPath.row
        self.navigationController?.pushViewController(nextScreen, animated: false)
    }

}
