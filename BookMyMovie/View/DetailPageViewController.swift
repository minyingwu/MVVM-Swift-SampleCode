//
//  DetailPageViewController.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/14.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

class DetailPageViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    var interactor:Interactor? = nil
    
    var movieItem: MovieList.MovieItem?
    
    lazy var movieDetailViewModel: BaseViewModel = {
        return MovieDetailViewModel(with: movieItem?.id ?? 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupViewModel()
    }
    
    func initView() {
        if let posterURL = movieItem?.poster_path {
            posterImageView.kf.setImage(with: URL(string: AppAPIAction.GET.fetchImage(posterURL).urlString))
        }else {
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.image = #imageLiteral(resourceName: "no_pic")
        }
    }
    
    func setupViewModel() {
        movieDetailViewModel.reloadUIClosure = { [weak self] isEmpty in
            
            guard !isEmpty else {
                return
            }
            
            let detailData = self?.movieDetailViewModel.dataList[0] as! MovieDetail
            DispatchQueue.main.async {
                if let self = self {
                    self.synopsisLabel.text = (detailData.overview == nil || detailData.overview == "") ? "NONE" : detailData.overview
                    let contentNeededSize = self.synopsisLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude))
                    
                    self.scrollViewHeightConstraint.constant =
                        (contentNeededSize.height > (300 - 85)) ? (contentNeededSize.height + 100) : 300
                    
                    self.languageLabel.text = "Language: " + (detailData.original_language ?? "N/A")
                    self.genresLabel.text = detailData.genres?.last?.name ?? ""
                    self.durationLabel.text = (detailData.runtime != nil) ? "Duration: " + String(detailData.runtime!) + "min": "Duration: " + "N/A"
                }
            }
        }
        
        movieDetailViewModel.fetchDataListfromServer()
    }
    
    @IBAction func bookingMovie() {
        present(BookingPageViewController(), animated: true)
    }
    
    @IBAction func backToMain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }
}
