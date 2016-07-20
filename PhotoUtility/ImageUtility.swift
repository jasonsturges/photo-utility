//
//  ImageUtility.swift
//  PhotoUtility
//
//  Created by Jason Sturges on 7/20/16.
//  Copyright © 2016 Jason Sturges. All rights reserved.
//

import Cocoa

class ImageUtility: NSObject {
    
    static func isImageFile(file:NSURL) -> Bool {
        switch file.pathExtension! {
        case "jpg",
             "jpeg",
             "png",
             "gif",
             "tif",
             "tiff",
             "cr",
             "cr2":
            return true
        default:
            return false
        }
    }
    
    static func isCameraRawFile(file:NSURL) -> Bool {
        switch file.pathExtension! {
        case "cr",
             "cr2":
            return true
        default:
            return false
        }
    }
    
}
