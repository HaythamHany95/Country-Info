//
//  ViewController.swift
//  Country Info
//
//  Created by Muhamed Alkhatib on 26/08/2020.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var countryAPI = CountryAPI()
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        
        searchTextField.delegate = self
        countryAPI.delegate = self
        locationManager.delegate = self
        
    }
    
    func customizeUI(){
        countryLabel.text = nil
        capitalLabel.text = nil
        regionLabel.text = nil
        populationLabel.text = nil
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        countryAPI.fetchData(countryName: searchTextField.text!)
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        countryAPI.fetchData(countryName: searchTextField.text!)
        return true
    }
}

extension ViewController: CountryAPIDelegate {
    func didRetrieveCountryData(country: Country) {
        
        DispatchQueue.main.async {
            print(country)
            self.countryLabel.text = "\(country.name?.official ?? "")"
            self.capitalLabel.text = "\(country.capital?[0] ?? "" )"
            self.regionLabel.text = country.region 
            self.populationLabel.text = String(country.population ?? 0)
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geoCoder.reverseGeocodeLocation(location) { [weak self] places, error in
//            print(places?.last?.country ?? "")
            guard let locationCountryName = places?.last?.country else { return }
            
            self?.countryAPI.fetchData(countryName: locationCountryName)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
