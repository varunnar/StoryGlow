//
//  environmentTableView.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/4/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class environmentTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var storyIndex = Int()
    
    let tableView: UITableView = {
        let SceneTableView = UITableView()
        SceneTableView.backgroundColor = UIColor.white
        SceneTableView.separatorColor = UIColor.white
        SceneTableView.translatesAutoresizingMaskIntoConstraints = false
        return SceneTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //if (GlobalVar.GlobalItems.firstOpening == true){
            setupTutorial()
        //}
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setupTutorial(){
        let nextScreen = tutorialPageViewController()
        nextScreen.tutorialPageArrayImage = ["SceneTable","SceneTableAddScene","SceneTableOpenScene","SceneTableDelete", "SceneTableMove"]
        nextScreen.tutorialPageArrayLabel = ["In the Scene Table you can view the scenes that you have already created in a story, created new scenes, navigate into your storyglow project, delete scenes and reorder them.", "By clicking the add button in the top right corner you can create a new scene. Like with the story table, you will not be immediately navigated into the storyglow project. That way you can setup multiple scenes at once.","Clicking on a scene will allow you to navigate into the storyglow project at that specific scene.","By swiping to the left on a story you can delete a scene. However, at least one story must always be present within the scene table.","By holding down on the scene, you can swap it with other scenes. This will also swap it's location within the storyglow project"]
        self.navigationController?.present(nextScreen, animated: true, completion: nil)
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(environmentCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sourceIndexPath.row]
        GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.remove(at: sourceIndexPath.row)
        GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.insert(movedObject, at: destinationIndexPath.row)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.count>1{
            GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            tableView.reloadData()
        }else{
            //Add alert to tell user you cannot delete that
            let alertConroller = UIAlertController(title: "WARNING", message: "You cannot delete this scene becuase it is the last one. Please add another scene or delete the story.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertConroller.addAction(alertAction)
            present(alertConroller,animated:true, completion: nil)
        }

    }

    //User presses add button in top corner to add a new scene
    @objc func addTapped()
    {
        let alert = UIAlertController(title: "Scene name", message: "What is the name of your new scene?", preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Done", style: .default, handler: { [unowned alert] _ in
            let answer = alert.textFields![0].text
            if (answer != ""){ //if scene actually has name
            let scene = GlobalVar.Scenes(sceneName: answer!)
            GlobalVar.GlobalItems.storyArray[self.storyIndex].sceneArray.append(scene)
            self.tableView.reloadData()//reload to tableview to see new name
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }


// MARK: - Table view data source
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.count
     }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! environmentCell
        if (GlobalVar.GlobalItems.storyArray.count != 0){
            cell.SceneLabel.text = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[indexPath.row].sceneName
            cell.backgroundColor = UIColor.white
            let strIndexPath = String(indexPath.row + 1)
            let test = strIndexPath.last!
            switch test {
                case "1":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.78, blue:0.37, alpha:1.00)
                case "2":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.59, blue:0.44, alpha:1.00)
                case "3":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.44, blue:0.57, alpha:1.00)
                case "4":
                    cell.cellView.backgroundColor = UIColor(red:0.84, green:0.36, blue:0.69, alpha:1.00)
                case "5":
                    cell.cellView.backgroundColor = UIColor(red:0.52, green:0.37, blue:0.76, alpha:1.00)
                case "6":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.78, blue:0.37, alpha:1.00)
                case "7":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.59, blue:0.44, alpha:1.00)
                case "8":
                    cell.cellView.backgroundColor = UIColor(red:1.00, green:0.44, blue:0.57, alpha:1.00)
                case "9":
                    cell.cellView.backgroundColor = UIColor(red:0.84, green:0.36, blue:0.69, alpha:1.00)
                case "0":
                    cell.cellView.backgroundColor = UIColor(red:0.52, green:0.37, blue:0.76, alpha:1.00)

                default:
                    cell.cellView.backgroundColor = UIColor.orange
            
            }
        }else{
            return UITableViewCell()
        }
        return cell
     }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextScreen = PageHolder()
        nextScreen.storyIndex = storyIndex
        nextScreen.currentSceneIndex = indexPath.row
        navigationController?.pushViewController(nextScreen, animated: false)
    }

}

//MARK:Extensions
extension environmentTableView: UITableViewDragDelegate {
func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension environmentTableView: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}
