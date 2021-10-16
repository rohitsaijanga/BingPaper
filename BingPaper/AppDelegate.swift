//
//  AppDelegate.swift
//  BingPaper
//
//  Created by Jingwen Peng on 2016-10-07.
//  Edited by Rohit Janga on 2021-05-02.
//  Copyright © 2021 Rohit Janga. All rights reserved.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var popover: NSPopover!
    
    override func awakeFromNib(){
        
        let statusBarItem = NSStatusBar.system.statusItem(withLength: -1);

        statusBarItem.view = StatusBarView(image: #imageLiteral(resourceName: "StatusBarIcon"), statusItem: statusBarItem, popover: self.popover)
    }
}
