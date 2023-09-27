//
//  CountryAp.swift
//  Country Info
//
//  Created by Haytham on 20/09/2023.
//

import Foundation

protocol CountryAPIDelegate {
    func didRetrieveCountryData(country: Country)
}

class CountryAPI {
    
    var delegate: CountryAPIDelegate?
    
    let baseURL = "https://restcountries.com/v3.1/name/"
    
    
    func fetchData(countryName: String) {
        guard let url = URL(string: "\(baseURL)\(countryName)") else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url, completionHandler: taskHandler)
        
        task.resume()
        
    }
    
    func taskHandler(data: Data?, urlResponse: URLResponse?, error: Error?) {
        
        do {
            let countries = try JSONDecoder().decode([Country].self, from: data!)
            let firstCountry = countries[0]
            
            delegate?.didRetrieveCountryData(country: firstCountry)
            
        } catch {
            print(error)
        }
    
    }
}



