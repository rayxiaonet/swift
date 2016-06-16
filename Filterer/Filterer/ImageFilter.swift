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

protocol ImageFilterProtocol{
    func apply(sourceImage:UIImage)-> UIImage
    func pixelFilterFunc(r:Int,g:Int,b:Int,a:Int) ->(r1:UInt8,g1:UInt8,b1:UInt8,a1:UInt8)

}


extension ImageFilterProtocol{
    
    func apply( sourceImage:UIImage)->UIImage {
        var src=RGBAImage(image:sourceImage)!

        for i in 0..<src.height*src.width {
            var pixel = src.pixels[i];
            let (r1,g1,b1,a1) = pixelFilterFunc(Int(pixel.red),g:Int(pixel.green),b:Int(pixel.blue),a:Int(pixel.alpha));
            pixel.red=r1
            pixel.green=g1
            pixel.blue=b1
            pixel.alpha=a1
            src.pixels[i]=pixel
        }
        return src.toUIImage()!
        
    }
}

class ImageFilter:ImageFilterProtocol {
    var red,green,blue,alpha:Int
    init(red:Int=0,green:Int=0,blue:Int=0,alpha:Int=0) {
        self.red = red;
        self.green = green;
        self.blue = blue;
        self.alpha = alpha;
    }
    func pixelFilterFunc(r:Int,g:Int,b:Int,a:Int) ->(r1:UInt8,g1:UInt8,b1:UInt8,a1:UInt8) {
        let r1=c(r+self.red)
        let g1=c(g+self.green)
        let b1=c(b+self.blue)
        let a1=c(a+self.alpha)
        return (r1,g1,b1,a1)
    }
}


