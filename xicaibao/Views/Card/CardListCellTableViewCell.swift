//
//  CardListCellTableViewCell.swift
//  RCloudMessage
//
//  Created by impressly on 2017/3/15.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

import UIKit

class CardListCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var card: Card? {
        didSet {
            guard let card = card  else { return }
            nameLabel.text = card.name
            photoImageView.image = UIImage(named: "mingpian_touxiang")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
