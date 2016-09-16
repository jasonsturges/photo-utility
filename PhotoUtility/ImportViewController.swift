//
//  ImportViewController.swift
//  PhotoUtility
//
//  Created by Jason Sturges on 7/19/16.
//  Copyright © 2016 Jason Sturges. All rights reserved.
//

import Cocoa

class ImportViewController: NSViewController {
    
    // MARK: Properties
    
    var inputFolderPath:[NSURL]!
    var outputJpegFolderPath:NSURL!
    var outputRawFolderPath:NSURL!
    
    
    // MARK: Outlets
    
    @IBOutlet weak var inputFolderTextField: NSTextField!
    
    @IBOutlet weak var inputFolderBrowseButton: NSButton!
    
    @IBOutlet weak var outputJpegFolderTextField: NSTextField!
    
    @IBOutlet weak var outputJpegFolderBrowseButton: NSButton!
    
    @IBOutlet weak var outputRawFolderTextField: NSTextField!
    
    @IBOutlet weak var outputRawFolderBrowseButton: NSButton!
    
    @IBOutlet weak var offsetTextField: NSTextField!
    
    @IBOutlet weak var importButton: NSButton!
    
    
    // MARK: Actions
    
    @IBAction func inputFolderBrowse(sender: AnyObject) {
        inputFolderPath = FileUtility.browseFiles()
        
        if (inputFolderPath != nil) {
            if (inputFolderPath.count == 1) {
                inputFolderTextField.stringValue = inputFolderPath.first!.path!
            } else if (inputFolderPath.count > 0) {
                inputFolderTextField.stringValue = "\(inputFolderPath.count) files"
            }
        }
    }
    
    
    @IBAction func outputJpegFolderBrowse(sender: AnyObject) {
        outputJpegFolderPath = FileUtility.browseFolder()
        
        if (outputJpegFolderPath != nil) {
            outputJpegFolderTextField.stringValue = outputJpegFolderPath!.path!
        }
    }
    
    
    @IBAction func outputRawFolderBrowse(sender: AnyObject) {
        outputRawFolderPath = FileUtility.browseFolder()
        
        if (outputRawFolderPath != nil) {
            outputRawFolderTextField.stringValue = outputRawFolderPath!.path!
        }
    }
    
    
    @IBAction func `import`(sender: AnyObject) {
            let fs = NSFileManager.defaultManager()
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            
            dispatch_async(queue) {
                for file:NSURL in self.inputFolderPath {
                    var isDir:ObjCBool = false
                    if fs.fileExistsAtPath(file.path!, isDirectory:&isDir) {
                        if isDir {
                            // file exists and is a directory
                        } else {
                            // file exists and is not a directory
                            if (ImageUtility.isImageFile(file)) {
                                if (ImageUtility.isCameraRawFile(file)) {
                                    FileUtility.copy(file, pathUrl: self.outputRawFolderPath, offset: self.offsetTextField.intValue)
                                } else {
                                    FileUtility.copy(file, pathUrl: self.outputJpegFolderPath, offset: self.offsetTextField.intValue)
                                }
                            }

                        }
                    } else {
                        // file does not exist
                    }
                }
            }
    }
    
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
