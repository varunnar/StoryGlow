//
//  URLbuilder.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/24/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation

func createURL(search:String, page:String) -> String {
    //let url = "https://freesound.org/apiv2/search/text/?query=" + search + "&page=" + page + "&token=L4bKom5YT2k8DfabolQKJ3duTAkFDIzTuZWnUzpC"
    
    let url = "https://freesound.org/apiv2/search/text/?query=" + search + "&fields=name,id,previews"
    return url
}

//MARK: need header set up to make download call?
func getSound(id:String) -> String{
    let downloadURL = "https://freesound.org/apiv2/sounds/" + id
    return downloadURL
}


