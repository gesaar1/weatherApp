//
//  EditWeatherInfoViewController.swift
//  App01
//
//  Created by Getter Saar on 20.01.2024.
//

import UIKit

class EditWeatherInfoViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    let dateFormatter = DateFormatter()
    
    // For core data db
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataController = DataController()
    
    var selectedInfo: WeatherInfo? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(selectedInfo != nil)
        {
            if let user = selectedInfo?.userID {
                userNameLabel.text = UserDataController().getUserById(id: user, context: context)?.name
            } else{
                userNameLabel.text = "Add user to see user info"
            }
            locationLabel.text = selectedInfo?.location
            dateLabel.text = selectedInfo?.date!.formatted(date: .long, time: .standard)
            
            if let temperature = selectedInfo?.temp {
                tempLabel.text = "\(temperature)"
            } else {
                tempLabel.text = "N/A"
            }
        }
    }
    
    
    @IBAction func deleteWeatherItemButton(_ sender: Any) {
        dataController.deleteItem(item: selectedInfo!, context: context)
        navigationController?.popViewController(animated: true)
        print("Deleted weather info")
}
    
}
