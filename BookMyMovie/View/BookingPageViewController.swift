//
//  BookingPageViewController.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/17.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit
import WebKit

class BookingPageViewController: UIViewController {
    
    let BOOKING_URL = URL(string: "https://www.cathaycineplexes.com.sg/")
    
    var bookingWebView: WKWebView!
    
    var dismissButton: UIButton!
    
    override func loadView() {
        bookingWebView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        bookingWebView.navigationDelegate = self
        
        self.view = bookingWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        dismissButton = UIButton(frame: CGRect(x: 5, y: 20, width: 50, height: 50))
        dismissButton.setImage(#imageLiteral(resourceName: "icon_close"), for: .normal)
        dismissButton.addTarget(self, action: #selector(backToDetail), for: .touchUpInside)
        bookingWebView.addSubview(dismissButton)
        
        if let url = BOOKING_URL {
            let request = URLRequest(url: url)
            bookingWebView.load(request)
            bookingWebView.allowsBackForwardNavigationGestures = true
        }
    }
    
    @objc func backToDetail(sender: AnyObject) {
        self.dismiss(animated: true)
    }
}

extension BookingPageViewController: WKNavigationDelegate {
    
}
