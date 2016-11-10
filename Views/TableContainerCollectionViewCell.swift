//
//  TableContainerCollectionViewCell.swift
//  BygApp
//
//  Created by Prince Agrawal on 27/07/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import UIKit

class TableContainerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
}

extension TableContainerCollectionViewCell: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionHeaderHeight
    }
}