//
//  ViewController.swift
//  App01
//
//  Created by Getter Saar on 25.01.2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    let locationService = LocationService()
    let dateFormatter = DateFormatter()
    let alertsController = AlertsController()
    
    let apiService = ApiService()
    
    //For core data db
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataController = DataController()
    let userController = UserDataController()
    
    private var weathers = [WeatherInfo]()
    private var users = [AppUser]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var isUserPresent = false
    var user: AppUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
        updateUI()

    }
    
    func getUser(){
        
        let users = userController.getAllUsers(context: context)
        if users.last != nil{
            user = users.last
            isUserPresent = true
        }
    }
    
    
    func createLabels() {
        let temp = apiService.getTemp()
        locationService.locationUpdateHandler = { [weak self] locationName in
            self?.locationLabel.text = locationName
            self?.tempLabel.text = String(temp)

            let date = Date()
            self?.updatedAtLabel.text = date.formatted(date: .long, time: .standard)
        }

        if let user = user, let userID = user.id {
            dataController.createItem(location: locationLabel.text!, temp: temp, userId: userID, context: context)
        } else {
            // Save without userID
            dataController.createItem(location: locationLabel.text!, temp: temp, context: context)
        }
    }


    @IBAction func updateTempButton(_ sender: Any) {
        
        locationManagerStatus(locationManager, didChangeAuthorization: locationManager.authorizationStatus)
        
    }
    
    
    private func locationManagerStatus(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // User granted permission, you can start updating location
            Task {
            
                do {
                    locationService.requestLocation()
                    
                    guard let latitude = locationService.currentLatitude, let longitude = locationService.currentLongitude else {

                        alertsController.showLocationErrorAlert(from: self)
                        print("Error getting location.")
                        print("Location manager authorization status:  \(locationManager.authorizationStatus.rawValue.description)")
                        return
                    }
                    
                    await apiService.get(lat: latitude, lon: longitude)
                    
                    createLabels()
                    updateUI()
                }
            }
        case .denied, .restricted:
            // User denied permission, show an alert
            alertsController.showLocationPermissionDeniedAlert(from: self)
            break
        default:
            break
        }
    }
    

    override func viewDidAppear(_ animated: Bool){
        getUser()
        updateUI()
    }
    
    
    private func updateUI() {
        weathers = dataController.getWeatherInfo(context: context)

        if let weather = weathers.last {
            locationLabel.text = weather.location
            updatedAtLabel.text = weather.date?.formatted(date: .long, time: .standard)
            tempLabel.text = String(weather.temp)
        } else {
            locationLabel.text = "No Location"
            updatedAtLabel.text = "No Date"
            tempLabel.text = "No Temperature"
        }
    }
    


    }
    

