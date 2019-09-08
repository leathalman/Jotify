//
//  UITableViewCell+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 9/7/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func applyConfig(for indexPath: IndexPath, numberOfCellsInSection: Int) {
        switch indexPath.row {
        case numberOfCellsInSection - 1:
            // This is the case when the cell is last in the section,
            // so we round to bottom corners
            self.roundCorners(.bottom, radius: 15)

            // However, if it's the only one, round all four
            if numberOfCellsInSection == 1 {
                self.roundCorners(.all, radius: 15)
            }
            
        case 0:
            // If the cell is first in the section, round the top corners
            self.roundCorners(.top, radius: 15)
            
        default:
            // If it's somewhere in the middle, round no corners
            self.roundCorners(.all, radius: 0)
        }
        
        if indexPath.row != 0 {
            let bottomBorder = CALayer()

            bottomBorder.frame = CGRect(x: 16.0, y: 0, width: self.contentView.frame.size.width - 16, height: 0.2)
            bottomBorder.backgroundColor = UIColor(white: 0.8, alpha: 1.0).cgColor
            self.contentView.layer.addSublayer(bottomBorder)
        }
    }
}
