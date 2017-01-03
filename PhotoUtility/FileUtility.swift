//
//  FileUtility.swift
//  PhotoUtility
//
//  Created by Jason Sturges on 7/19/16.
//  Copyright © 2016 Jason Sturges. All rights reserved.
//

import Cocoa

class FileUtility: NSObject {
    
    static func browseFiles() -> [URL] {
        
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
        
        return dialog.urls
    }
    
    
    static func browseFolder() -> URL! {
        
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
        
        return dialog.url
    }
    
    
    static func copy(_ file:URL, pathUrl:URL, offset:Int32 = 0) {
        let fs:FileManager = FileManager.default
        
        do {
            var dest:URL
            
            if (offset != 0) {
                let filename = file.deletingPathExtension().lastPathComponent
                let fileExtension = file.pathExtension
                
                if ((filename.lowercased().hasPrefix("dscf") == true) ||
                    (filename.lowercased().hasPrefix("img_") == true)) {
                    
                    let prefix = filename.startIndex ..< filename.characters.index(filename.startIndex, offsetBy: 4)
                    let count = filename.characters.index(filename.startIndex, offsetBy: 4) ..< filename.endIndex
                    var n = Int32(filename[count])!
                    n += offset;
                    
                    dest = URL(fileURLWithPath: "\(filename[prefix])\(String(format: "%04d", n)).\(fileExtension)", relativeTo: pathUrl)

                } else {
                    dest = URL(fileURLWithPath: file.lastPathComponent, relativeTo: pathUrl)
                }
            } else {
                dest = URL(fileURLWithPath: file.lastPathComponent, relativeTo: pathUrl)
            }
            
            try fs.copyItem(at: file, to: dest)
            
        } catch let error  {
            print (error)
        }
    }
    
}
