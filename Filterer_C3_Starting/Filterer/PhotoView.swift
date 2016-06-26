//
//  PhotoView.swift
//  Filterer
//
//  Created by Ray Xiao on 6/25/16.
//  Copyright © 2016 UofT. All rights reserved.
//
import UIKit


class PhotoView :UIImageView{
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent:event)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent:event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent:event)

    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent:event)

    }
    
}