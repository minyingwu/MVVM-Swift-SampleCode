//
//  BookMyMovieTests.swift
//  BookMyMovieTests
//
//  Created by Victor on 2019/2/14.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest
@testable import BookMyMovie

class BookMyMovieTests: XCTestCase {
    
    static let TEST_MOVIE_ID = 432374
    
    var mock_url_session: MockURLSession = MockURLSession()
    
    var mock_api_session: APISession!
    
    var sut_movie_list: MovieListViewModel! = MovieListViewModel()
    
    var sut_movie_detail: MovieDetailViewModel! = MovieDetailViewModel(with: TEST_MOVIE_ID)
    
    var sut_main_page_view_controller: MainPageViewController!

    var sut_detail_page_view_controller: DetailPageViewController!
    
    var sut_booking_page_view_controller: BookingPageViewController!
    
    override func setUp() {
        super.setUp()
        mock_api_session = APISession(httpClient: HttpClient(session: mock_url_session))
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut_main_page_view_controller = storyboard.instantiateViewController(withIdentifier: "main_page_view_controller") as? MainPageViewController
        sut_detail_page_view_controller = storyboard.instantiateViewController(withIdentifier: "detail_page_view_controller") as? DetailPageViewController
        sut_booking_page_view_controller = BookingPageViewController()
        _ = sut_booking_page_view_controller.view
    }

    override func tearDown() {
        super.tearDown()
        sut_movie_list = nil
        sut_movie_detail = nil
        sut_main_page_view_controller = nil
        sut_detail_page_view_controller = nil
        sut_booking_page_view_controller = nil
    }
    
    func test_fetch_movie_list_from_server_success() {
        let expectation = XCTestExpectation(description: "Wait for movie list.")
        
        sut_movie_list.fetchDataListfromServer() {
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetch_more_movie_list_from_server_success() {
        let expectation = XCTestExpectation(description: "Wait for more movie list.")
        
        sut_movie_list.fetchMoreData(with: 2){
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetch_movie_detail_from_server_success() {
        let expectation = XCTestExpectation(description: "Wait for movie detail.")
        
        sut_movie_detail.fetchDataListfromServer() {
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_get_movie_list_by_release() {
        mock_url_session.nextData = Data()
        mock_api_session.getMovieListByRelease(onPage: 1) { (data, response, error) in
            XCTAssertNil(error, "Server connect error")
            XCTAssertNotNil(data, "Server data is empty")
        }
    }
    
    func test_get_detail_movie_info() {
        mock_url_session.nextData = Data()
        mock_api_session.getDetailMovieInfo(by: 1) { (data, response, error) in
            XCTAssertNil(error, "Server connect error")
            XCTAssertNotNil(data, "Server data is empty")
        }
    }
    
    func test_get_detail_movie_info_success() {
        sut_movie_detail.fetchDataListfromServer()
        mock_url_session.nextData = Data()
        mock_api_session.getDetailMovieInfo(by: BookMyMovieTests.TEST_MOVIE_ID) { (data, response, error) in
            XCTAssertNil(error, "Server connect error")
            XCTAssertNotNil(data, "Server data is empty")
        }
    }
    
    func test_get_more_movie_list_by_release_success() {
        sut_movie_list.fetchMoreData(with: 2)
        mock_url_session.nextData = Data()
        mock_api_session.getMovieListByRelease(onPage: 2) { (data, response, error) in
            XCTAssertNil(error, "Server connect error")
            XCTAssertNotNil(data, "Server data is empty")
        }
    }
    
    func test_fetch_data_list_from_server() {
        sut_movie_list.fetchDataListfromServer()
        sut_movie_detail.fetchDataListfromServer()
        XCTAssert(self.sut_movie_list.loadingState == .start)
    }
    
    func test_get_request_with_URL() {
        guard let url = URL(string: "http://api.themoviedb.org/3/movie/432374?api_key=dbbc5f9c21cd388646a6c5455acc8b6c") else {
            fatalError("URL can't be empty")
        }
        mock_api_session.getDetailMovieInfo(by: BookMyMovieTests.TEST_MOVIE_ID) { (data, response, error) in
            XCTAssert(self.mock_url_session.lastURL == url)
        }
    }
    
    func test_get_movie_list_by_release_failed() {
        mock_url_session.nextError = ErrorState.networkError
        mock_api_session.getMovieListByRelease(onPage: 1) { (data, response, error) in
            if let errorState = error as? ErrorState {
                guard errorState != ErrorState.networkError else {
                    return
                }
                XCTFail()
            }else {
                XCTFail()
            }
        }
    }
    
    func test_get_detail_movie_info_failed() {
        mock_url_session.nextError = ErrorState.networkError
        mock_api_session.getDetailMovieInfo(by: BookMyMovieTests.TEST_MOVIE_ID) { (data, response, error) in
            if let errorState = error as? ErrorState {
                guard errorState != ErrorState.networkError else {
                    return
                }
                XCTFail()
            }else {
                XCTFail()
            }
        }
    }
    
    func test_open_booking_page_controller() {
        XCTAssertEqual(sut_booking_page_view_controller.bookingWebView.url, URL(string: "https://www.cathaycineplexes.com.sg/"))
    }
    
    func test_controller_error_alert() {
        sut_main_page_view_controller.movieListViewModel.showAlertClosure = { [weak self ] error in
            guard let errorState = error as? ErrorState else {
                XCTFail()
                return
            }
            XCTAssertTrue(errorState == ErrorState.networkError)
            self?.sut_main_page_view_controller.presentErrorAlert(by: errorState)
        }
        sut_main_page_view_controller.movieListViewModel.errorState = ErrorState.networkError
        
        sut_detail_page_view_controller.movieDetailViewModel.showAlertClosure = { [weak self ] error in
            guard let errorState = error as? ErrorState else {
                XCTFail()
                return
            }
            XCTAssertTrue(errorState == ErrorState.networkError)
            self?.sut_detail_page_view_controller.presentErrorAlert(by: errorState)
        }
        sut_detail_page_view_controller.movieDetailViewModel.errorState = ErrorState.networkError
    }
    
    func test_controller_loading_state() {
        sut_main_page_view_controller.movieListViewModel.updateLoadingClosure = { [weak self] state in
            XCTAssertTrue(state == .start)
            self?.sut_detail_page_view_controller.startLoading()
        }
        sut_main_page_view_controller.movieListViewModel.loadingState = .start
        
        sut_detail_page_view_controller.movieDetailViewModel.updateLoadingClosure = { [weak self] state in
            XCTAssertTrue(state == .start)
            self?.sut_detail_page_view_controller.startLoading()
        }
        sut_detail_page_view_controller.movieDetailViewModel.loadingState = .start
    }
    
    func test_controller_reload_data() {
        sut_main_page_view_controller.movieListViewModel.reloadUIClosure = { isEmpty in
            XCTAssertFalse(isEmpty)
        }
        sut_main_page_view_controller.movieListViewModel.dataList = [MovieList.MovieItem(id: 432374, popularity: 0.6, title: "Dawn French Live: 30 Million Minutes", poster_path: "/cTUuMb83O9kFcXnQIQMgehEJX70.jpg", backdrop_path: "/27RY4W57D6HWlY3FPmSphiIXco0.jpg")]
        
        sut_detail_page_view_controller.movieDetailViewModel.reloadUIClosure = { isEmpty in
            XCTAssertFalse(isEmpty)
        }
        sut_detail_page_view_controller.movieDetailViewModel.dataList = [MovieDetail(genres: [MovieDetail.Genres(name: "Comedy")], original_language: "en", overview: "Dawn French stars in her acclaimed one-woman show, the story of her life, filmed during its final West End run.", runtime: 120)]
    }
}

class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
    
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
