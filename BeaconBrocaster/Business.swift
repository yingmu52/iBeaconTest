//
//  Business.swift
//  
//
//  Created by Xinyi Zhuang on 25/03/2018.
//

import Foundation
import CoreLocation

struct Business: Decodable {
  let name: String
  let image_url: String
  let is_closed: Bool
  let url: String
  let rating: Double
  let coordinates: Location
  let price: String?
  let phone: String
  let display_phone: String
  let distance: Double
  let review_count: Int
}

struct Location: Decodable {
  let latitude: Double
  let longitude: Double
}

struct DataStream: Decodable {
  let businesses: [Business]
  let total: Int
}
