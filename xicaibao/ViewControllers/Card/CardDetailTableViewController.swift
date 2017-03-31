//
//  CardDetailTableViewController.swift
//  RCloudMessage
//
//  Created by impressly on 2017/3/16.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

import Foundation
import UIKit

class CardDetailTableViewController: UITableViewController {
    
    var card: Card?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var comButton: UIButton!
    @IBOutlet weak var comCell: UITableViewCell!
    @IBOutlet weak var nameBackView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBaseView()
        setupInfoView()
    }
    
    private func  setupInfoView() {
        guard let card = self.card else { return }
        
        nameLabel.text = card.name
        jobLabel.text = card.job
        telLabel.text = card.tel
        addressLabel.text = card.address
        comButton.setTitle(card.com, for: .normal)
    }
    
    private func setupBaseView() {
        title = "名片详情"
        // 去掉cell的分割线
        comCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, comCell.bounds.size.width)
        comButton.isEnabled = false
        nameBackView.layer.cornerRadius = 10
        comButton.layer.cornerRadius = 25
        photoImageView.layer.cornerRadius = photoImageView.bounds.height / 2.0
        
    }
}
