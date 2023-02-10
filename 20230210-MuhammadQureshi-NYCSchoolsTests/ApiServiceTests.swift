//
//  ApiServiceTests.swift
//  20230210-MuhammadQureshi-NYCSchools
//
//  Created by Muhammad Qureshi on 2/10/23.
//

import XCTest
@testable import _0230210_MuhammadQureshi_NYCSchools

final class ApiServiceTests: XCTestCase {
    
    // Test fetching data with a valid URL and valid data
    func testFetchDataWithValidURLAndValidData() {
        let expectation = self.expectation(description: "fetchData")
        let url = URL(string: EndPoint.highSchoolsList.rawValue)!
        APIService.fetchData(from: url, type: [HightSchoolDataModel].self) { result in
            switch result {
            case .success(let posts):
                XCTAssertGreaterThan(posts.count, 0)
            case .failure(let error):
                XCTFail("Fetch data failed with error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    // Test fetching data with an invalid URL
    func testFetchDataWithInvalidURL() {
        let expectation = self.expectation(description: "fetchData")
        let url = URL(string: "invalid_url")!
        APIService.fetchData(from: url, type: [HightSchoolDataModel].self) { result in
            switch result {
            case .success(_):
                XCTFail("Fetch data succeeded with an invalid URL")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
   // Test fetching data with an invalid data format
    func testFetchDataWithInvalidDataFormat() {
        let expectation = self.expectation(description: "fetchData")
        let url = URL(string: EndPoint.highSchoolsList.rawValue)!
        APIService.fetchData(from: url, type: [String].self) { result in
            switch result {
            case .success(_):
                XCTFail("Fetch data succeeded with an invalid data format")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
