//
//  ImageFilter.swift
//  Filterer
//
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

//limit color with range of 0-255, and convert to UInt8
func c(color:Int)->UInt8 {
    return UInt8(max(min(color,255),0))
}


class RGBAImageFilter {
    var filterRed:Bool
    var filterGreen:Bool
    var filterBlue:Bool
    var filterAlpha:Bool
    init(filterRed:Bool=false,filterGreen:Bool=false,filterBlue:Bool=false,filterAlpha:Bool=false){
        self.filterRed=filterRed
        self.filterGreen=filterGreen
        self.filterBlue=filterBlue
        self.filterAlpha=filterAlpha
    }
    
    func apply(sourceImage:UIImage,val:Int=0)->UIImage {
        var src=RGBAImage(image:sourceImage)!
        
        for i in 0..<src.height*src.width {
            var pixel = src.pixels[i];
            if (filterRed) {
                pixel.red=c(Int(pixel.red)+val)
            }
            if (filterGreen) {
                
                pixel.green=c(Int(pixel.green)+val)
            }
            if (filterBlue) {
                
                pixel.blue=c(Int(pixel.blue)+val)
            }
            if (filterAlpha) {
                
                pixel.alpha=c(Int(pixel.alpha)+val)
            }
            src.pixels[i]=pixel
        }
        return src.toUIImage()!
    }
}

