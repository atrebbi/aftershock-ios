//
//  ConsoleCell.swift
//  Aftershock
//
//  Created by Anatoly Vdovichev on 20/04/2019.
//  Copyright © 2019 ASVCorp. All rights reserved.
//

import Foundation
import UIKit

class ConsoleLine: UITableViewCell {

    @IBOutlet weak var lineText: UILabel!

    func setText(text: String) {
        lineText.text = text
    }
}
