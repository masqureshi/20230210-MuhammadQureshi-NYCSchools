//
//  HighSchoolListViewModelTests.swift
//  20230210-MuhammadQureshi-NYCSchools
//
//  Created by Muhammad Qureshi on 2/10/23.
//

import XCTest
@testable import _0230210_MuhammadQureshi_NYCSchools

class HighSchoolListViewModelDelegateMock: HighSchoolListViewModelDelegate {
    var highSchoolsDidChangeCalled = false
    var highSchoolAdditionalInfoDidChangeCalled = false
    var errorFallBackCalled = false
    
    var errorString: String?
    
    func highSchoolsDidChange() {
        highSchoolsDidChangeCalled = true
    }
    
    func highSchoolAdditionalInfoDidChange() {
        highSchoolAdditionalInfoDidChangeCalled = true
    }
    
    func errorFallBack(errorString: String) {
        errorFallBackCalled = true
        self.errorString = errorString
    }
}

class HighSchoolListViewModelTests: XCTestCase {
    var viewModel: HighSchoolListViewModel!
    var delegate: HighSchoolListViewModelDelegateMock!
    
    override func setUp() {
        super.setUp()
        delegate = HighSchoolListViewModelDelegateMock()
        viewModel = HighSchoolListViewModel()
        viewModel.delegate = delegate
    }
    
    override func tearDown() {
        delegate = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchHighSchoolsSuccess() {
        let expectation = self.expectation(description: "fetchData")
        guard let url = URL(string: EndPoint.highSchoolsList.rawValue) else {
            return
        }
        APIService.fetchData(from: url, type: [HightSchoolDataModel].self) {result in
            switch result {
            case .success(let highSchoolsData):
                XCTAssertGreaterThan(highSchoolsData.count, 0)
            case .failure(let error):
                XCTFail("Fetch data failed with error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchHighSchoolsFailure() {
        let expectation = self.expectation(description: "fetchData")
        guard let url = URL(string: "null") else {
            return
        }
        APIService.fetchData(from: url, type: [HightSchoolDataModel].self) {result in
            switch result {
            case .success:
                XCTFail("Fetch data succeeded with an invalid URL")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchHighSchoolsInvalidDataFormat() {
        let expectation = self.expectation(description: "fetchData")
        guard let url = URL(string: EndPoint.highSchoolsList.rawValue) else {
            return
        }
        APIService.fetchData(from: url, type: [String].self) {result in
            switch result {
            case .success:
                XCTFail("Fetch data succeeded with an invalid data format")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchHighSchoolsInfoSuccess() {
        let expectation = self.expectation(description: "fetchData")
        guard let url = URL(string: EndPoint.highScoolAdditionalInfo.rawValue + "01M292") else {
            return
        }
        APIService.fetchData(from: url, type: [SchoolAdditionalInfoModel].self) {result in
            switch result {
            case .success(let highSchoolInfoData):
                XCTAssertGreaterThan(highSchoolInfoData.count, 0)
            case .failure(let error):
                XCTFail("Fetch data failed with error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchHighSchoolsInfoFailure() {
        let expectation = self.expectation(description: "fetchData")
        guard let url = URL(string: "null") else {
            return
        }
        APIService.fetchData(from: url, type: [SchoolAdditionalInfoModel].self) {result in
            switch result {
            case .success:
                XCTFail("Fetch data succeeded with an invalid URL")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchHighSchoolsInfoInvalidDataFormat() {
        let expectation = self.expectation(description: "fetchData")
        guard let url = URL(string: EndPoint.highSchoolsList.rawValue + "01M292") else {
            return
        }
        APIService.fetchData(from: url, type: [String].self) {result in
            switch result {
            case .success:
                XCTFail("Fetch data succeeded with an invalid data format")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    
    func testNumberOfRows() {
        viewModel.highSchools = [HightSchoolDataModel(school_name: "Test School 1", dbn: "01M292")]
            XCTAssertEqual(viewModel.numberOfRows, 1)
        }
        
        func testTitleForRowAtIndexPath() {
            viewModel.highSchools = [HightSchoolDataModel(school_name: "Test School 1", dbn: "01M292")]
            XCTAssertNotNil(viewModel.titleForRowAtIndexPath(IndexPath(row: 0, section: 0)))
        }
        
        func testDBNForRowAtIndexPath() {
            viewModel.highSchools = [HightSchoolDataModel(school_name: "Test School 1", dbn: "01M292")]
            XCTAssertEqual(viewModel.dbnForRowAtIndexPath(IndexPath(row: 0, section: 0)), "01M292")
        }
        
        func testSetupAlertForSchoolMoreDetail() {
            viewModel.highSchoolAdditionalInfo = SchoolAdditionalInfoModel(dbn: "01M292", num_of_sat_test_takers: "10", sat_critical_reading_avg_score: "400", sat_math_avg_score: "500", sat_writing_avg_score: "300")
            let (title, details) = viewModel.setupAlertForSchoolMoreDetail()
            XCTAssertNotNil(title)
            XCTAssertNotNil(details)
        }
}
