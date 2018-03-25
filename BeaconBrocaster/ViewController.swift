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

class ViewController: UIViewController {
  @IBOutlet var textView: UITextView!
  @IBOutlet var button: UIButton!

  lazy var manager: CLLocationManager = {
    let mgr = CLLocationManager()
    mgr.delegate = self
    return mgr
  }()

  let beaconRegion: CLBeaconRegion = {
    let uuid = UUID(uuidString: "05F62A3D-F60F-44BC-B36E-2B80FD6C9679")!
    let identifier = UIDevice.current.identifierForVendor?.uuidString
    return CLBeaconRegion(proximityUUID: uuid, major: 52, minor: 88, identifier: identifier!)
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    manager.requestWhenInUseAuthorization()
    textView.text = nil
    button.setTitle("Start", for: .normal)
    button.setTitle("Monitoring...", for: .selected)
  }

  @IBAction func buttonPressed(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    if sender.isSelected {
      manager.startRangingBeacons(in: beaconRegion)
//      manager.stopMonitoring(for: beaconRegion)
    } else {
      manager.stopRangingBeacons(in: beaconRegion)
//      manager.startMonitoring(for: beaconRegion)
    }
  }
}

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//    manager.startRangingBeacons(in: beaconRegion)
    textView.text = "Entered Region"
  }

  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//    manager.stopRangingBeacons(in: beaconRegion)
    textView.text = "Existed Region"
  }
  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    textView.text = "Ranged Beacon Region\n"
    for b in beacons {
      textView.text = textView.text + String(b.description)
    }
  }
}
