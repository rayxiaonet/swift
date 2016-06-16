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
    
    
    func apply(sourceImage:UIImage,red:Int=0,green:Int=0,blue:Int=0,alpha:Int=0)->UIImage {
        var src=RGBAImage(image:sourceImage)!
        
        for i in 0..<src.height*src.width {
            var pixel = src.pixels[i];
            pixel.red=c(Int(pixel.red)+red)
            pixel.green=c(Int(pixel.green)+green)
            pixel.blue=c(Int(pixel.blue)+blue)
            pixel.alpha=c(Int(pixel.alpha)+alpha)
            src.pixels[i]=pixel
        }
        return src.toUIImage()!
    }
}


