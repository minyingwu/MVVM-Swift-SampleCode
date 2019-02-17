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
    
    var movieItem: MovieList.MovieItem!
    
    fileprivate lazy var movieDetailViewModel: BaseViewModel = {
        return MovieDetailViewModel(with: movieItem.id)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupViewModel()
    }
    
    func initView() {
        if let posterURL = movieItem.poster_path {
            posterImageView.kf.setImage(with: URL(string: AppAPIAction.GET.fetchImage(posterURL).urlString))
        }else {
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.image = #imageLiteral(resourceName: "no_pic")
        }
    }
    
    func setupViewModel() {
        movieDetailViewModel.showAlertClosure = { [weak self] error in
            
        }
        
        movieDetailViewModel.updateLoadingClosure = { [weak self] state in
            
        }
        
        movieDetailViewModel.reloadUIClosure = { [weak self] isEmpty in
            
            guard !isEmpty else {
                return
            }
            
            let detailData = self?.movieDetailViewModel.dataList[0] as! MovieDetail
            DispatchQueue.main.async {
                if let self = self {
                    self.synopsisLabel.text = detailData.overview
                    let contentNeededSize = self.synopsisLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude))
                    
                    self.scrollViewHeightConstraint.constant =
                        (contentNeededSize.height > (300 - 85)) ? (contentNeededSize.height + 100) : 300
                    
                    self.languageLabel.text = "Language: " + (detailData.original_language ?? "NONE")
                    self.genresLabel.text = detailData.genres?.last?.name ?? ""
                    self.durationLabel.text = (detailData.runtime != nil) ? "Duration: " + String(detailData.runtime!) + "min": "Duration: " + "NONE"
                }
            }
        }
        
        movieDetailViewModel.fetchDataListfromServer()
    }
    
    @IBAction func bookingMovie() {
        self.present(BookingPageViewController(), animated: true)
    }
    
    @IBAction func backToMain(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
