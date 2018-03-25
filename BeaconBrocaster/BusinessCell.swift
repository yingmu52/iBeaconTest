//
//  BusinessCell.swift
//  Alamofire
//
//  Created by Xinyi Zhuang on 25/03/2018.
//

import UIKit
import Cosmos
import Snakepit

class BusinessCell: UITableViewCell {
  @IBOutlet weak var businessImageView: UIImageView!
  @IBOutlet weak var businessName: UILabel!
  @IBOutlet weak var businessRating: CosmosView!
  @IBOutlet weak var businessAccessaryLabel: UILabel!
  @IBOutlet weak var businessContentLabel: UILabel!
  @IBOutlet weak var businessDistanceLabel: UILabel!
  @IBOutlet weak var businessBackgroundView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    businessImageView.image = nil
    businessName.text = nil
    businessAccessaryLabel.text = nil
    businessContentLabel.text = nil
    businessDistanceLabel.text = nil

    let shadowPath = UIBezierPath(rect: businessBackgroundView.bounds)
    businessBackgroundView.layer.masksToBounds = false
    businessBackgroundView.layer.shadowColor = UIColor.black.cgColor
    businessBackgroundView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
    businessBackgroundView.layer.shadowOpacity = 0.2
    businessBackgroundView.layer.shadowPath = shadowPath.cgPath
  }
}
