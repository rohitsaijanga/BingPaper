//
//  GeneralPreferencesViewController.swift
//  BingPaper
//
//  Created by Jingwen Peng on 2016-10-07.
//  Edited by Rohit Janga on 2021-05-02.
//  Copyright © 2021 Rohit Janga. All rights reserved.

import Cocoa
import ServiceManagement
import MASPreferences

class GeneralPreferencesViewController: NSViewController, MASPreferencesViewController {
    var viewIdentifier: String = "General"
    var toolbarItemImage: NSImage? = #imageLiteral(resourceName: "Switch")
    var toolbarItemLabel: String? = NSLocalizedString("General", comment: "N/A")
    
    @IBOutlet weak var autoStartCheckButton: NSButton!
    @IBOutlet weak var dockIconCheckButton: NSButton!
    @IBOutlet weak var autoDownloadCheckButton: NSButton!
    @IBOutlet weak var autoChangeWallpaperCheckButton: NSButton!
    @IBOutlet weak var regionSelectPopUp: PopUpButtonCell!
    @IBOutlet weak var regionSelectMenu: NSMenu!
    @IBOutlet weak var storagePathButton: NSButton!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: "GeneralPreferencesView", bundle: Bundle())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOptions()
        loadPreferences()
    }
    
    func loadOptions() {
        for regionName in SharedBingRegion.All.keys.sorted() {
            let regionValue = SharedBingRegion.All[regionName]
            let item = MenuItem.init(title: regionName, action: #selector(self.selectRegion(_:)), keyEquivalent: "")
            item.target = self
            item.value = regionValue
            self.regionSelectMenu.addItem(item)
        }
    }
    
    func loadPreferences() {
        autoStartCheckButton.state = NSControl.StateValue(rawValue: SharedPreferences.bool(forKey: SharedPreferences.Key.WillLaunchOnSystemStartup) ? 1 : 0)
        dockIconCheckButton.state = NSControl.StateValue(rawValue: SharedPreferences.bool(forKey: SharedPreferences.Key.WillDisplayIconInDock) ? 1 : 0)
        
        autoDownloadCheckButton.state = NSControl.StateValue(rawValue: SharedPreferences.bool(forKey: SharedPreferences.Key.WillAutoDownloadNewImages) ? 1 : 0)
        
        autoChangeWallpaperCheckButton.state = NSControl.StateValue(rawValue: SharedPreferences.bool(forKey: SharedPreferences.Key.WillAutoChangeWallpaper) ? 1 : 0)
        autoChangeWallpaperCheckButton.isEnabled = SharedPreferences.bool(forKey: SharedPreferences.Key.WillAutoDownloadNewImages)
        
        if let region = SharedPreferences.string(forKey: SharedPreferences.Key.CurrentSelectedBingRegion) {
            self.regionSelectPopUp.selectItem(withValue: region)
        }
        
        if let storagePath = SharedPreferences.string(forKey: SharedPreferences.Key.DownloadedImagesStoragePath) {
            self.storagePathButton.title = storagePath
        }
    }
    
    @IBAction func toggleLaunchOnSystemStartup(_ sender: NSButton) {
        let isEnabled = sender.state.rawValue == 1 ? true : false

        SharedPreferences.set(isEnabled, forKey: SharedPreferences.Key.WillLaunchOnSystemStartup)
        
        SMLoginItemSetEnabled("io.pjw.mac.BingPaperLoginItem" as CFString, isEnabled)
    }
    
    @IBAction func toggleDockIcon(_ sender: NSButton) {
        let isOn = sender.state.rawValue == 1 ? true : false
        
        SharedPreferences.set(isOn, forKey: SharedPreferences.Key.WillDisplayIconInDock)
        
        if isOn {
            NSApplication.shared.setActivationPolicy(NSApplication.ActivationPolicy.regular)
        } else {
            NSApplication.shared.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
        }
    }
    
    @IBAction func toggleDownload(_ sender: NSButton) {
        let isEnabled = sender.state.rawValue == 1 ? true : false
        
        SharedPreferences.set(sender.state.rawValue == 1 ? true : false, forKey: SharedPreferences.Key.WillAutoDownloadNewImages)
        
        autoChangeWallpaperCheckButton.isEnabled = isEnabled
    }
    
    @IBAction func toggleChangeWallpaper(_ sender: NSButton) {
        SharedPreferences.set(sender.state.rawValue == 1 ? true : false, forKey: SharedPreferences.Key.WillAutoChangeWallpaper)
    }
    
    @IBAction func selectRegion(_ sender: MenuItem) {
        if let value = sender.value {
            SharedPreferences.set(value, forKey: SharedPreferences.Key.CurrentSelectedBingRegion)
        }
    }
    
    @IBAction func viewStoragePath(_ sender: NSButton) {
        NSWorkspace.shared.openFile(self.storagePathButton.title)
    }
    
    @IBAction func changeStoragePath(_ sender: NSButton) {
        let openPanel = NSOpenPanel();
        openPanel.showsResizeIndicator = true
        openPanel.showsHiddenFiles = false
        openPanel.canChooseFiles = false;
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.allowsMultipleSelection = false
        
        openPanel.beginSheetModal(for: self.view.window!) { (response) -> Void in
            if response == NSApplication.ModalResponse.OK {
                if let path = openPanel.url?.path {
                    SharedPreferences.set(path, forKey: SharedPreferences.Key.DownloadedImagesStoragePath)
                    
                    self.loadPreferences()
                }
            }
        }
    }
    
    @IBAction func resetPreferences(_ sender: NSButton) {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Reset Warning", comment: "N/A")
        alert.informativeText = NSLocalizedString("Are you sure to reset you would like to reset the preferences?", comment: "N/A")
        alert.addButton(withTitle: NSLocalizedString("Reset", comment: "N/A"))
        alert.addButton(withTitle: NSLocalizedString("Cancel", comment: "N/A"))
        alert.alertStyle = NSAlert.Style.warning
        
        alert.beginSheetModal(for: self.view.window!, completionHandler: { (response) -> Void in
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                SharedPreferences.clear()
                
                self.loadPreferences()
            }
        })
    }
}
