//
//  FileUtility.swift
//  PhotoUtility
//
//  Created by Jason Sturges on 7/19/16.
//  Copyright © 2016 Jason Sturges. All rights reserved.
//

import Cocoa

class FileUtility: NSObject {
    
    static func browseFiles() -> [NSURL] {
        
        let dialog = NSOpenPanel()
        
        dialog.title = "Choose files"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = true
        dialog.allowsMultipleSelection = true
        
        if (dialog.runModal() != NSModalResponseOK) {
            return []
        }
        
        return dialog.URLs
    }
    
    
    static func browseFolder() -> NSURL! {
        
        let dialog = NSOpenPanel()
        
        dialog.title = "Choose folder"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        dialog.allowsMultipleSelection = false
        
        if (dialog.runModal() != NSModalResponseOK) {
            return nil
        }
        
        return dialog.URL
    }
    
    
    static func copy(file:NSURL, pathUrl:NSURL, offset:Int32 = 0) {
        let fs:NSFileManager = NSFileManager.defaultManager()
        
        do {
            var dest:NSURL
            
            if (offset != 0) {
                let filename = file.URLByDeletingPathExtension?.lastPathComponent
                let fileExtension = file.pathExtension
                
                if ((filename?.lowercaseString.hasPrefix("dscf") == true) ||
                    (filename?.lowercaseString.hasPrefix("img_") == true)) {
                    
                    let prefix = filename!.startIndex ..< filename!.startIndex.advancedBy(4)
                    let count = filename!.startIndex.advancedBy(4) ..< filename!.endIndex
                    var n = Int32(filename![count])!
                    n += offset;
                    
                    dest = NSURL(fileURLWithPath: "\(filename![prefix])\(String(format: "%04d", n)).\(fileExtension!)", relativeToURL: pathUrl)

                } else {
                    dest = NSURL(fileURLWithPath: file.lastPathComponent!, relativeToURL: pathUrl)
                }
            } else {
                dest = NSURL(fileURLWithPath: file.lastPathComponent!, relativeToURL: pathUrl)
            }
            
            try fs.copyItemAtURL(file, toURL: dest)
            
        } catch let error  {
            print (error)
        }
    }
    
}
