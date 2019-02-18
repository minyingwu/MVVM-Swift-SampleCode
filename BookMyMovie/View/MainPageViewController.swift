//
//  MainPageViewController.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/14.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var mTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    fileprivate lazy var movieListViewModel: BaseViewModel = {
        return MovieListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupViewModel()
    }
    
    func initView() {
        refreshControl.addTarget(self, action: #selector(pullDownRefresh), for: .valueChanged)
        
        mTableView.addSubview(refreshControl)
        mTableView.tableFooterView = UIView()
    }
    
    func setupViewModel() {
        movieListViewModel.showAlertClosure = { [weak self] error in
            DispatchQueue.main.async {
                self?.presentErrorAlert(by: error)
            }
        }
        
        movieListViewModel.updateLoadingClosure = { [weak self] state in
            DispatchQueue.main.async {
                if let self = self {
                    switch state {
                    case .start:
                        self.startLoading()
                    case .stop:
                        self.stopLoading()
                    }
                }
            }
        }
        
        movieListViewModel.reloadUIClosure = { [weak self] isEmpty in
            DispatchQueue.main.async {
                if let self = self {
                    self.mTableView.reloadData()
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
        
        movieListViewModel.fetchDataListfromServer()
    }
    
    @objc func pullDownRefresh(sender: AnyObject) {
        movieListViewModel.fetchDataListfromServer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? DetailPageViewController {
            let index = (sender as! UITableViewCell).tag
            destinationController.movieItem = self.movieListViewModel.dataList[index] as? MovieList.MovieItem
        }
    }
    
}

extension MainPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= (UIScreen.main.bounds.height / 3) {
            if !movieListViewModel.noMore {
                movieListViewModel.fetchMoreData(with: movieListViewModel.loadedPage + 1)
            }
        }
    }
}

extension MainPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewModel.numberOfData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "main_table_cell", for: indexPath)
        return movieListViewModel.getUpdatedDataCell(at: indexPath, cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

class MainTableCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var backdropImageView: UIImageView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    func setupBackgroundBlurred() {
        posterImageView = posterImageView.blurred
    }
    
}
