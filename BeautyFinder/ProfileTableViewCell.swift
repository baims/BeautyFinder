//
//  ProfileTableViewCell.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 1/27/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit
import MarqueeLabel_Swift

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var salonLogo: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var salonNameLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var addressLabel: MarqueeLabel!
}
