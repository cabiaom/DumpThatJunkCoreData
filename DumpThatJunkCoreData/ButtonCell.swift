//
//  ButtonCell.swift
//  DumpThatJunkCoreData
//
//  Created by Mark CABIAO on 4/3/16.
//  Copyright © 2016 Mark CABIAO. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate {
    func cellTapped(cell: ButtonCell)
}

class ButtonCell: UITableViewCell {

   
    var buttonDelegate: ButtonCellDelegate?
    //@IBOutlet weak var rowLabel: UILabel!
    
    @IBAction func buttonTap(sender: AnyObject) {
        if let delegate = buttonDelegate {
            delegate.cellTapped(self)
        }
    }
    

}
