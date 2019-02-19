//
//  BaseViewModel.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/14.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

typealias CompletionHandler = (()->(Void))

protocol BaseData {}

class BaseViewModel {
    var dataList: [BaseData] = [BaseData]() {
        didSet {
            reloadUIClosure?(numberOfData > 0 ? false : true)
        }
    }
    
    var errorState: Error =  ErrorState.networkError {
        didSet {
            showAlertClosure?(errorState)
        }
    }
    
    var loadingState: LoadingState = .stop {
        didSet {
            updateLoadingClosure?(loadingState)
        }
    }
    
    // For more pages
    var loadedPage: Int = 1 {
        didSet {
            if loadedPage <= numberOfPages {
                noMore = false
            }else {
                noMore = true
            }
        }
    }
    
    var numberOfData: Int {
        return dataList.count
    }
    
    var numberOfPages: Int = 1
    
    var noMore: Bool = false
    
    var showAlertClosure: ((Error)->())?
    
    var reloadUIClosure: ((_ isEmpty: Bool)->())?
    
    var updateLoadingClosure: ((LoadingState)->())?
    
    func getData(at index: Int) -> BaseData? {
        return dataList[index]
    }
    
    func fetchDataListfromServer(completionHandler: CompletionHandler? = nil) {
        fatalError("Must override this method to fetch different data list")
    }
    
    func getUpdatedDataCell(at indexPath: IndexPath, _ cell: UITableViewCell) -> UITableViewCell {
        fatalError("Must override this method to handle custom cell")
    }
    
    func fetchMoreData(with pageNum: Int, completionHandler: CompletionHandler? = nil) {}
}

enum ErrorState: Error {
    case networkError
    case requestURLError
}

enum LoadingState {
    case start
    case stop
}

extension ErrorState {
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Network error"
        case .requestURLError:
            return "Server error"
        }
    }
}

