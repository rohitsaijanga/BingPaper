//
//  PopUpButtonCell.swift
//  BingPaper
//
//  Created by Jingwen Peng on 2016-10-07.
//  Edited by Rohit Janga on 2021-05-02.
//  Copyright © 2021 Rohit Janga. All rights reserved.


import Cocoa

class PopUpButtonCell: NSPopUpButtonCell {
    
    func selectItem(withValue: String) {
        for index in 0 ..< numberOfItems {
            if let menuItem = item(at: index) as? MenuItem? {
                if menuItem?.value == withValue {
                    selectItem(at: index)
                    return
                }
            }
        }
    }
}
