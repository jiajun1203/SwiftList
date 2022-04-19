//
//  MRC_ItemCell.swift
//  OpenColseList
//
//  Created by William on 2022/3/11.
//

import UIKit

class MRC_ItemCell: UITableViewCell {

    @IBOutlet weak var view_Avtivity: UIActivityIndicatorView!
    @IBOutlet weak var lead_Space: NSLayoutConstraint!
    @IBOutlet weak var lab_Title: UILabel!
    @IBOutlet weak var imgv_Left: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.loadingEnd()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadingStart(){
        view_Avtivity.isHidden = false
        view_Avtivity.startAnimating()
    }
    func loadingEnd(){
        view_Avtivity.isHidden = true
        view_Avtivity.stopAnimating()
    }
}
