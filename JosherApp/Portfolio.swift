//
//  Portfolio.swift
//  JosherApp
//
//  Created by Josher Slebodnik on 9/24/15.
//  Copyright © 2015 Josh Slebodnik. All rights reserved.
//

import UIKit

class Portfolio: NSObject {
    var title: String
    var theDescription: String
    var theThumbnail: String
    var image1: String
    var image2: String
    var image3: String
    
    
    
    init(title: String, description: String, thumbnail: String, image1: String, image2: String, image3: String){
        self.title = title
        self.theDescription = description
        self.theThumbnail  = thumbnail
        self.image1 = image1
        self.image2 = image2
        self.image3 = image3
    }
    
    
    
    
}
