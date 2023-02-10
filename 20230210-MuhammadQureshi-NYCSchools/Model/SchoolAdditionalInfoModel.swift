//
//  SchoolAdditionalInfoModel.swift
//  20230210-MuhammadQureshi-NYCSchools
//
//  Created by Muhammad Qureshi on 2/10/23.
//

import Foundation

struct SchoolAdditionalInfoModel: Decodable {
    let dbn: String?
    let num_of_sat_test_takers: String?
    let sat_critical_reading_avg_score: String?
    let sat_math_avg_score: String?
    let sat_writing_avg_score: String?
}
