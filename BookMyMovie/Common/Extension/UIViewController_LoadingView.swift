//
//  UIViewController_LoadingView.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/18.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var indicatorViewController: IndicatorViewController {
        return IndicatorViewController()
    }
    
    func startLoading() {
        let indicatorView = indicatorViewController
        indicatorView.modalPresentationStyle = .custom
        if presentedViewController == nil {
            present(indicatorView, animated: false, completion: nil)
        }
    }
    
    func stopLoading() {
        if presentedViewController is IndicatorViewController {
            dismiss(animated: false, completion: nil)
        }
    }
}

class IndicatorViewController: UIViewController {
    
    fileprivate var indicatorView: UIActivityIndicatorView!
    
    override func loadView() {
        setUpUI()
    }
    
    func setUpUI(){
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black
        view.alpha = 0.7
        
        indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicatorView.style = .whiteLarge
        indicatorView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        indicatorView.startAnimating()
        view.addSubview(indicatorView!)
    }
}


