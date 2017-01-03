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
    
    var inputFolderPath:[URL]!
    var outputJpegFolderPath:URL!
    var outputRawFolderPath:URL!
    
    
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
    
    @IBAction func inputFolderBrowse(_ sender: AnyObject) {
        inputFolderPath = FileUtility.browseFiles() as [URL]!
        
        if (inputFolderPath != nil) {
            if (inputFolderPath.count == 1) {
                inputFolderTextField.stringValue = inputFolderPath.first!.path
            } else if (inputFolderPath.count > 0) {
                inputFolderTextField.stringValue = "\(inputFolderPath.count) files"
            }
        }
    }
    
    
    @IBAction func outputJpegFolderBrowse(_ sender: AnyObject) {
        outputJpegFolderPath = FileUtility.browseFolder() as URL!
        
        if (outputJpegFolderPath != nil) {
            outputJpegFolderTextField.stringValue = outputJpegFolderPath!.path
        }
    }
    
    
    @IBAction func outputRawFolderBrowse(_ sender: AnyObject) {
        outputRawFolderPath = FileUtility.browseFolder() as URL!
        
        if (outputRawFolderPath != nil) {
            outputRawFolderTextField.stringValue = outputRawFolderPath!.path
        }
    }
    
    
    @IBAction func `import`(_ sender: AnyObject) {
            let fs = FileManager.default
            let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
            
            queue.async {
                for file:URL in self.inputFolderPath {
                    var isDir:ObjCBool = false
                    if fs.fileExists(atPath: file.path, isDirectory:&isDir) {
                        if isDir.boolValue {
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
