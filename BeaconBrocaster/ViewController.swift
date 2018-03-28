//
//  ViewController.swift
//  BeaconBrocaster
//
//  Created by Xinyi Zhuang on 24/03/2018.
//  Copyright © 2018 x52. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import Snakepit
import Alamofire
import Kingfisher
import HGPlaceholders

class ViewController: UITableViewController {

  // Backgroudn Task ID
  var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

  // Location Manager
  lazy var manager: CLLocationManager = {
    let mgr = CLLocationManager()
    mgr.delegate = self
    return mgr
  }()

  // Beacon Region
  let beaconRegion: CLBeaconRegion = {
    let uuid = UUID(uuidString: "05F62A3D-F60F-44BC-B36E-2B80FD6C9679")!
    let identifier = UIDevice.current.identifierForVendor?.uuidString
    return CLBeaconRegion(proximityUUID: uuid, major: 52, minor: 88, identifier: identifier!)
  }()

  // Data Srouce From Yelp
  var business = [Business]()

  deinit { NotificationCenter.default.removeObserver(self) }

  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(reinstateBackgroundTask),
      name: NSNotification.Name.UIApplicationDidBecomeActive,
      object: nil
    )

    // request beacon access
    if CLLocationManager.authorizationStatus() != .authorizedAlways {
      manager.requestAlwaysAuthorization()
    } else {
      manager.startRangingBeacons(in: beaconRegion)
      registerBackgroundTask()
    }

    // setup tableview
    tableView.dataSource = self
    tableView.delegate = self
  }
}

extension ViewController {
  func setBlackNavLogo() {
    let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 51, height: 22))
    titleImageView.image = #imageLiteral(resourceName: "find_wordmark_k")
    navigationItem.titleView = titleImageView
  }

  @objc func getRecommendation() {

    guard let location = manager.location else {
      showAlert(title: "Failed to get location")
      return
    }
    if business.count != 0 { return } // only load once
    let lat = location.coordinate.latitude
    let lon = location.coordinate.longitude
    let endpoint = "https://api.yelp.com/v3/businesses/search?term=coffee&latitude=\(lat)&longitude=\(lon)"
    var request = URLRequest(url: URL(string: endpoint)!)
    request.allHTTPHeaderFields = [
      "Authorization": "Bearer XTpHOwRjAxnu2-LC6NHCA1M5hO-HddCO0l10x3K55RKfhVWnLi7g3W4OxrF03ov80DB9dBzNPOWCCV51ijIg70bHqSXDnigtEirRjUSYYJfBHhgURIxARrHsBkS3WnYx",
      "Content-Type": "application/json"
    ]
    tableView.refreshControl?.beginRefreshing()
    Alamofire.request(request).response { (resp) in
      guard let dat = resp.data else { return }
      do {
        let json = try JSONDecoder().decode(DataStream.self, from: dat)
        self.business = json.businesses
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        print("loaded data")
      } catch let e {
        print(e)
      }
    }
  }
}

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .denied || status == .notDetermined {
      showAlert(title: "Please turn on location service")

    }
  }

  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    if UIApplication.shared.applicationState != .active {
      print("didRangeBeacons")
    }
    guard let beacon = beacons.last else { return }
    if beacon.proximity.rawValue > 1 { // Out of range
      navigationItem.titleView = nil
      business.removeAll()
      tableView.reloadData()
      navigationItem.title = "Outside of Beacon Range"
    } else { // In range
      print("in ranged")
      setBlackNavLogo()
      getRecommendation()
    }
  }

  func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
    showAlert(title: "Failed to range beacon", message: error.localizedDescription)
  }
}

extension ViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 335 }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return business.count }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.deque(cell: BusinessCell.self, for: indexPath)
    let b = business[indexPath.row]
    cell.businessName.text = b.name
    cell.businessRating.rating = b.rating
    cell.businessAccessaryLabel.text = "\(((b.price != nil) ? b.price! + " - " : "" ))" + "\(b.review_count) reviews"
    cell.businessDistanceLabel.text = String(format: "%.1fkm", b.distance / 1000)
    cell.businessContentLabel.text = b.is_closed ? "Closed" : "Open Now"
    if let url = URL(string: b.image_url) {
      cell.businessImageView.kf.setImage(with: url)
    }
    return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let b = business[indexPath.row]
    let webVC = Storyboard.Main.get(WebViewController.self)
    webVC.stringURL = b.url
    navigationController?.pushViewController(webVC, animated: true)
  }
}

extension ViewController {
  @objc func reinstateBackgroundTask() {
    if backgroundTask == UIBackgroundTaskInvalid {
      registerBackgroundTask()
    }
  }

  func registerBackgroundTask() {
    backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
      self?.endBackgroundTask()
    }
    assert(backgroundTask != UIBackgroundTaskInvalid)
  }

  func endBackgroundTask() {
    print("Background task ended.")
    UIApplication.shared.endBackgroundTask(backgroundTask)
    backgroundTask = UIBackgroundTaskInvalid
  }
}

enum Storyboard: String, StoryboardGettable {
  case Main
  var bundle: Bundle? { return Bundle.main }
}
