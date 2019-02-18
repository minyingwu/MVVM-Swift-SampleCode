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
    
    override func setUp() {
        super.setUp()
        mock_api_session = APISession(httpClient: HttpClient(session: mock_url_session))
    }

    override func tearDown() {
        super.tearDown()
        sut_movie_list = nil
        sut_movie_detail = nil
    }
    
    func test_get_movie_list_by_release_success() {
        APISession.shared.getMovieListByRelease(onPage: 1) { (data, response, error) in
            XCTAssertNil(error, "Server connect error")
            XCTAssertNotNil(data, "Server data is empty")
        }
    }
    
    func test_get_detail_movie_info_success() {
        APISession.shared.getDetailMovieInfo(by: BookMyMovieTests.TEST_MOVIE_ID) { (data, response, error) in
            XCTAssertNil(error, "Server connect error")
            XCTAssertNotNil(data, "Server data is empty")
        }
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
