//
//  AboutPreferencesViewController.swift
//  BingPaper
//
//  Created by Jingwen Peng on 2016-10-07.
//  Edited by Rohit Janga on 2021-05-02.
//  Copyright © 2021 Rohit Janga. All rights reserved.


import Cocoa
import MASPreferences

class AboutPreferencesViewController: NSViewController, MASPreferencesViewController {
        
    var viewIdentifier: String = "About"
    var toolbarItemImage: NSImage? = #imageLiteral(resourceName: "Envolope")
    var toolbarItemLabel: String? = NSLocalizedString("About", comment: "N/A")
    
    @IBOutlet weak var versionAndBuildString: NSTextField!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: "AboutPreferencesView", bundle: Bundle())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStrings()
    }

    func loadStrings() {
        let prefix = "\(NSLocalizedString("Version", comment: "N/A")): "
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let build = Bundle.main.infoDictionary?["CFBundleVersion"]
        
        versionAndBuildString.stringValue = "\(prefix)\(version!) (\(build!))"
    }

    @IBAction func openEmail(_ sender: NSButton) {
        NSWorkspace.shared.open(NSURL(string: "mailto:rohitsaistark@gmail.com")! as URL)
    }
    
    @IBAction func openWebsite(_ sender: NSButton) {
        NSWorkspace.shared.open(NSURL(string: "https://rohitsaijanga.github.io/")! as URL)
    }
}
