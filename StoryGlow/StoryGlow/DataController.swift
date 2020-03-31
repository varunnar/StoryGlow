//
//  DataController.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 3/21/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit

class DataController{

        // Do any additional setup after loading the view
    func getDocumentUrl()->URL{
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            return url
        }
        else{
            return URL(fileURLWithPath: "")
        }
    }
    
    func saveStoriesToDisk(stories: [GlobalVar.Story]) {
        // 1. Create a URL for documents-directory/posts.json
        let url = getDocumentUrl().appendingPathComponent("stories.json")
        // 2. Endcode our [Post] data to JSON Data
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(stories)
            // 3. Write this data to the url specified in step 1
            try data.write(to: url, options: [])
            print("stories are encoding")
        } catch {
            fatalError("could no write data")
        }
    }
    
    
    
    func getStoriesFromDisk()->[GlobalVar.Story]{
        // 1. Create a url for documents-directory/posts.json
        let url = getDocumentUrl().appendingPathComponent("stories.json")
        let decoder = JSONDecoder()
        do {
                // 2. Retrieve the data on the file in this path (if there is any)
            let data = try Data(contentsOf: url, options: [])
                // 3. Decode an array of Posts from this Data
            let stories = try decoder.decode([GlobalVar.Story].self, from: data)
            GlobalVar.tutorial.firstOpening = false
            return stories
        } catch {
            return []
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
