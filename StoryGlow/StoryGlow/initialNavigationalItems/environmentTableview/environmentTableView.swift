//
//  environmentTableView.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/4/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class environmentTableView: UITableViewController {
    
    var storyIndex = Int()
    
    struct cells {
        static let cellID = "cellID" //why is this in a struct?
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewCell()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[sourceIndexPath.row]
        GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.remove(at: sourceIndexPath.row)
        GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.insert(movedObject, at: destinationIndexPath.row)
    }

 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.count>1{
            GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
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
            let scene = GlobalVar.Scenes(sceneName: answer!, colorVal: .white)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray.count
    }
    
    func setupTableViewCell()
    {
        tableView.register(environmentCell.self, forCellReuseIdentifier: cells.cellID)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells.cellID, for: indexPath) as! environmentCell
        if (GlobalVar.GlobalItems.storyArray.count != 0){
            cell.environmentName.text = GlobalVar.GlobalItems.storyArray[storyIndex].sceneArray[indexPath.row].sceneName
        }
        else{
            return UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextScreen = PageHolder()
        nextScreen.storyIndex = storyIndex
        nextScreen.currentSceneIndex = indexPath.row
        navigationController?.pushViewController(nextScreen, animated: false)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
