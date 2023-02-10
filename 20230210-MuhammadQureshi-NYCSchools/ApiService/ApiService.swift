//
//  ApiService.swift
//  20230210-MuhammadQureshi-NYCSchools
//
//  Created by Muhammad Qureshi on 2/10/23.
//

import Foundation

// Enum for api call endpoints
enum EndPoint: String {
    case highSchoolsList = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
    case highScoolAdditionalInfo = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?dbn="
}


///This method takes a URL and a completion handler as its parameters, and uses URLSession to make a data task to fetch the data from the URL. The method returns the data as a Result object, which either contains the decoded data of type T or an Error. The type T must conform to the Decodable protocol, which allows it to be decoded from the data received from the API.

class APIService {
    class func fetchData<T: Decodable>(from url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "APIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data is nil"])
                completion(.failure(error))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                completion(.success(decodedData))
                return
            } catch {
                completion(.failure(error))
                return
            }
        }
        task.resume()
    }
}

enum APIError: Error {
    case noData
}
