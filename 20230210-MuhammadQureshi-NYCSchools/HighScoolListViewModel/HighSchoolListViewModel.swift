//
//  HighSchoolListViewModel.swift
//  20230210-MuhammadQureshi-NYCSchools
//
//  Created by Muhammad Qureshi on 2/10/23.
//

import Foundation

protocol HighSchoolListViewModelDelegate: AnyObject {
    func highSchoolsDidChange()
    func highSchoolAdditionalInfoDidChange()
    func errorFallBack(errorString: String)
}


class HighSchoolListViewModel {
    //MARK: *********  properties  *********
    weak var delegate: HighSchoolListViewModelDelegate?
    var highSchools: [HightSchoolDataModel] = []
    var highSchoolAdditionalInfo: SchoolAdditionalInfoModel?
    
    var numberOfRows: Int {
        return highSchools.count
    }
    
    //MARK: *********  functions  *********
    // returning title for row
    func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        return highSchools[indexPath.row].school_name ?? "--"
    }
    
    // returning dbn for row
    func dbnForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        return highSchools[indexPath.row].dbn ?? ""
    }
    
    func setupAlertForSchoolMoreDetail() -> (String , String) {
        let title = "SAT Takers: \(highSchoolAdditionalInfo?.num_of_sat_test_takers ?? "0")\n"
        let mathScore = "Math\t\t\(highSchoolAdditionalInfo?.sat_math_avg_score ?? "0")\n"
        let Reading = "Reading\t\t\(highSchoolAdditionalInfo?.sat_critical_reading_avg_score ?? "0")\n"
        let writing = "Writing\t\t\(highSchoolAdditionalInfo?.sat_writing_avg_score ?? "0")\n"
        let AllScoreSet = "Subject\t\tScore\n\n" + mathScore + Reading + writing
        return (title,AllScoreSet)
    }
    
    // fetching schools list
    func fetchHighSchools() {
        guard let url = URL(string: EndPoint.highSchoolsList.rawValue) else {
            return
        }
        
        APIService.fetchData(from: url, type: [HightSchoolDataModel].self) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let highSchoolsData):
                self.highSchools = highSchoolsData
                self.delegate?.highSchoolsDidChange()
            case .failure(let error):
                self.delegate?.errorFallBack(errorString: error.localizedDescription)
            }
        }
    }
    
    // fetching SAT and additionalInfo
    func fetchSATAndHighSchoolAdditionalInfo(dbn: String) {
        guard let url = URL(string: EndPoint.highScoolAdditionalInfo.rawValue + dbn) else {
            return
        }
        
        APIService.fetchData(from: url, type: [SchoolAdditionalInfoModel].self) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let highSchoolAdditionalData):
                self.highSchoolAdditionalInfo = highSchoolAdditionalData.first
                self.delegate?.highSchoolAdditionalInfoDidChange()
            case .failure(let error):
                self.delegate?.errorFallBack(errorString: error.localizedDescription)
            }
        }
    }
}
