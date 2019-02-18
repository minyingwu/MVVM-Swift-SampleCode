//
//  UIViewController+AlertView.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/18.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(by errorState: Error) {
        if let errorState = errorState as? ErrorState {
            switch errorState {
            case .networkError:
                let alert = UIAlertController(title: errorState.localizedDescription, message: "Failed to connect to the network, please check network settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            case .requestURLError:
                let alert = UIAlertController(title: errorState.localizedDescription, message: "Failed to find the search result from movie server, please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
