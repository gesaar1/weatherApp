//
//  AlertsController.swift
//  App01
//
//  Created by Getter Saar on 20.01.2024.
//

import Foundation
import UIKit

class AlertsController{
    
    
    func showInfoAlert(from viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }

        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showLocationPermissionDeniedAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Location Access Denied",
            message: "Please enable location access in Settings to use this feature.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showLocationErrorAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Location problem",
            message: "Error occurred when retrieving location. Try again later.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        viewController.present(alert, animated: true, completion: nil)
    }
        
}
