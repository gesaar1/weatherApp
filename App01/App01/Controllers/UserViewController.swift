//
//  UserViewController.swift
//  App01
//
//  Created by Getter Saar on 03.01.2024.
//



import Foundation
import UIKit
import CoreData

class UserViewController: UIViewController {

    // For core data db
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataController = DataController()
    let userDataController = UserDataController()
    
    
    @IBOutlet weak var addButton: UIButton!


    
    let defaultImage = UIImage(named: "Sample_User_Icon")

    @IBOutlet weak var addUserButton: UIBarButtonItem!
    
    private var users = [AppUser]()
    private var weathers = [WeatherInfo]()

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    override func viewDidLoad() {

        super.viewDidLoad()
        setUpImageView()
        updateUI()
        }

    private func setUpImageView() {
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 3.0
        userImageView.layer.borderColor = UIColor.lightGray.cgColor
    }

    private func setUpUser(){
        let user = users.last
        userImageView.image = UIImage(data: user!.picture!)
        userNameLabel.text = user!.name
        addButton.titleLabel?.text = "Edit"
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        updateUI()
    }
    
    private func updateUI() {
        users = userDataController.getAllUsers(context: context)
        
        if let user = users.last {
            userImageView.image = UIImage(data: user.picture!)
            userNameLabel.text = user.name
            addUserButton.title = "Edit"
            addButton.titleLabel?.text = "Edit"
        } else {
            // Handle the case when there are no users
            userImageView.image = defaultImage
            userNameLabel.text = "Add new user"
            addUserButton.title = "Add"
            addButton.titleLabel?.text = "Add"
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if users.last != nil{
            if let userInfo = segue.destination as? AddUserViewController {
                userInfo.activeUser = users.last
            }
        }
    }

}
