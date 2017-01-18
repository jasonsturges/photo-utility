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
    
    var inputFiles: [URL]!
    var outputJpegFolder: URL!
    var outputRawFolder: URL!
    var offset: Int32 = 0
    
    
    // MARK: Outlets
    
    @IBOutlet weak var inputFolderTextField: NSTextField!
    
    @IBOutlet weak var inputFolderBrowseButton: NSButton!
    
    @IBOutlet weak var outputJpegFolderTextField: NSTextField!
    
    @IBOutlet weak var outputJpegFolderBrowseButton: NSButton!
    
    @IBOutlet weak var outputRawFolderTextField: NSTextField!
    
    @IBOutlet weak var outputRawFolderBrowseButton: NSButton!
    
    @IBOutlet weak var offsetTextField: NSTextField!
    
    @IBOutlet weak var importButton: NSButton!

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    
    // MARK: Actions
    
    @IBAction func inputFolderBrowse(_ sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories    = false
        openPanel.canChooseFiles          = true
        openPanel.showsHiddenFiles        = false
        openPanel.allowsMultipleSelection = true
        
        openPanel.beginSheetModal(for: self.view.window!) { (response) -> Void in
            guard response == NSFileHandlingPanelOKButton else {return}
            self.inputFiles = openPanel.urls
            
            self.inputFolderTextField.stringValue = "\(self.inputFiles.count) files"
            
            self.progressIndicator.minValue = 0
            self.progressIndicator.maxValue = Double(self.inputFiles.count)
            self.progressIndicator.doubleValue = 0.0
        }
    }
    
    
    @IBAction func outputJpegFolderBrowse(_ sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories  = true
        openPanel.canChooseFiles        = false
        openPanel.canCreateDirectories  = true
        openPanel.showsHiddenFiles      = false
        
        openPanel.beginSheetModal(for: self.view.window!) { (response) -> Void in
            guard response == NSFileHandlingPanelOKButton else {return}
            if let URL = openPanel.url {
                self.outputJpegFolder = URL
                self.outputJpegFolderTextField.stringValue = URL.path
            }
        }
    }
    
    
    @IBAction func outputRawFolderBrowse(_ sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories  = true
        openPanel.canChooseFiles        = false
        openPanel.canCreateDirectories  = true
        openPanel.showsHiddenFiles      = false
        
        openPanel.beginSheetModal(for: self.view.window!) { (response) -> Void in
            guard response == NSFileHandlingPanelOKButton else {return}
            if let URL = openPanel.url {
                self.outputRawFolder = URL
                self.outputRawFolderTextField.stringValue = URL.path
            }
        }
    }
    
    
    @IBAction func `import`(_ sender: AnyObject) {
        let fs = FileManager.default
        outputJpegFolder = URL(fileURLWithPath: outputJpegFolderTextField.stringValue)
        outputRawFolder = URL(fileURLWithPath: outputRawFolderTextField.stringValue)
        offset = offsetTextField.intValue
        importButton.isEnabled = false
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            for file:URL in self.inputFiles {
                var isDir:ObjCBool = false
                if fs.fileExists(atPath: file.path, isDirectory:&isDir) {
                    if isDir.boolValue {
                        // file exists and is a directory
                    } else {
                        // file exists and is not a directory
                        if (ImageUtility.isImageFile(file)) {
                            if (ImageUtility.isCameraRawFile(file)) {
                                FileUtility.copy(file, pathUrl: self.outputRawFolder, offset: self.offset)
                            } else {
                                FileUtility.copy(file, pathUrl: self.outputJpegFolder, offset: self.offset)
                            }
                        }
                    }
                } else {
                    // file does not exist
                }
                
                DispatchQueue.main.async {
                    self.progressIndicator.increment(by: 1.0)
                }
            }
            DispatchQueue.main.async {
                self.importButton.isEnabled = true
            }
        }
    }
    
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressIndicator.isIndeterminate = false
    }
    
}
