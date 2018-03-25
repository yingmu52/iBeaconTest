//
//  WebViewController.swift
//  AiReceipts
//
//  Created by Tony Zhuang on 2018-01-08.
//  Copyright © 2018 Qileap Analytics Inc. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
  var stringURL: String?
  @IBOutlet var webView: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if self.navigationController?.viewControllers.first == self {
      // webview is created as root view controller in a navigation stack, need to add a close button
      let close = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
      self.navigationItem.rightBarButtonItem = close
    }
    if self.stringURL == nil {
      self.stringURL = "https://www.rexeipt.com/"
    }
    guard let s = self.stringURL, let url = URL(string: s) else { return }
    self.webView.loadRequest(URLRequest(url: url))
  }
  
  @objc func dismissView() {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
}
