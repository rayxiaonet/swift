//
//  GalleryImage.swift
//  Filterer
//
//  Created by Ray Xiao on 7/23/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation


struct GalleryImageItem {
    let url: String
    let title: String
    let date:NSDate
}



class GalleryImage {
   
    
    var items: [GalleryImageItem]
    var loadedDate: NSDate
    
    init(items newItems:[GalleryImageItem],toDate:NSDate) {
        items = newItems
        loadedDate = toDate
    }
    
    
}