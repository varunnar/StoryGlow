//
//  storyTableView.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/1/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class storyTableView: UITableViewController {
    
    struct cells {
        static let cellID = "cellID" //why is this in a struct?
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewCell()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
        
    //Function that runs when user clicks the tab button in the top right corner. Creates an new story and prompts user through alerts
    @objc func addTapped()
    {
        let alert = UIAlertController(title: "Story name", message: "What is the name of your story?", preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Next", style: .default, handler: { [unowned alert] _ in
            let answer = alert.textFields![0].text
            if (answer != ""){
                let story = GlobalVar.Story(storyName: answer!)
                GlobalVar.GlobalItems.storyArray.append(story)
                self.SceneNameAlert()
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
    func SceneNameAlert()
    {
        let alert = UIAlertController(title: "Scene name", message: "What is the name of your first scene?", preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Done", style: .default, handler: { [unowned alert] _ in
            let answer = alert.textFields![0].text
            if (answer != ""){
                let scene = GlobalVar.Scenes(sceneName: answer!, colorVal: .white)
                GlobalVar.GlobalItems.storyArray[GlobalVar.GlobalItems.storyArray.count-1].sceneArray.append(scene)
                self.tableView.reloadData()
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
    
    func setupTableViewCell()
    {
        tableView.register(storyCell.self, forCellReuseIdentifier: cells.cellID)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GlobalVar.GlobalItems.storyArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cells.cellID, for: indexPath) as! storyCell
        if (GlobalVar.GlobalItems.storyArray.count != 0){
            cell.storyName.text = GlobalVar.GlobalItems.storyArray[indexPath.row].storyName
        }
        else{
            return UITableViewCell()
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextScreen = environmentTableView()
        nextScreen.title = GlobalVar.GlobalItems.storyArray[indexPath.row].storyName
        nextScreen.storyIndex = indexPath.row
        self.navigationController?.pushViewController(nextScreen, animated: false)
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
