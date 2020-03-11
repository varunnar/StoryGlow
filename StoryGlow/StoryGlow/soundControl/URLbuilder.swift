//
//  URLbuilder.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 2/24/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import Foundation
//create URL for API call
func createURL(search:String, page:String) -> String {
    let url = "https://freesound.org/apiv2/search/text/?query=" + search + "&fields=name,id,previews"
    return url
}



