//
//  BeaconTableView.swift
//  BeaconBrocaster
//
//  Created by Xinyi Zhuang on 25/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit
import HGPlaceholders

class BeaconTableView: TableView {

  override func customSetup() {
    placeholdersProvider = .default
  }
}
