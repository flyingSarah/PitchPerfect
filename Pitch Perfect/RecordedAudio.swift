//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Sarah Howe on 5/14/15.
//  Copyright (c) 2015 SarahHowe. All rights reserved.
//

import Foundation


class RecordedAudio
{
    var filePathURL: NSURL!
    var title: String!
    
    /*  was clued in on how to do this from jMarcano's response to this thread in the discussion forum: http://discussions.udacity.com/t/add-an-initialiser-to-class/18222 */
    init(filePathURL: NSURL, title: String)
    {
        self.filePathURL = filePathURL
        self.title = title
    }
}