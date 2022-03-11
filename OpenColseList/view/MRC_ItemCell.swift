//
//  MRC_ItemCell.swift
//  OpenColseList
//
//  Created by William on 2022/3/11.
//

import UIKit

class MRC_ItemCell: UITableViewCell {

    @IBOutlet weak var lead_Space: NSLayoutConstraint!
    @IBOutlet weak var lab_Title: UILabel!
    @IBOutlet weak var imgv_Left: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
