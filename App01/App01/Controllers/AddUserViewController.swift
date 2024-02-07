//
//  AddUserViewController.swift
//  App01
//
//  Created by Getter Saar on 03.01.2024.
//



import UIKit
import CoreData


class AddUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var activeUser: AppUser? = nil
    
    //For core data db
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let userDataController = UserDataController()
    let alertsController = AlertsController()
    
    let defaultImage = UIImage(named: "Sample_User_Icon")
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpImageView()
        
        if activeUser != nil{
            setUpUser()
        } else{
            deleteButton.isHidden = true
        }
    }
    
    
    private func setUpImageView(){
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.image = defaultImage
        imageView.backgroundColor = .white
    }
    
    @IBAction func deleteUserButton(_ sender: Any) {
        userDataController.deleteUser(item: activeUser!, context: context)
        navigationController?.popViewController(animated: true)
        print("Deleted user")
    }
    
    @IBAction func imageViewButton(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    @IBAction func saveUserDataButton(_ sender: Any) {
        
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            alertsController.showInfoAlert(from: self, title: "Missing name", message: "Please insert name")
            return
        }
        guard let userImage = imageView.image, !userImage.isEqual(UIImage()) else {
            alertsController.showInfoAlert(from: self, title: "Missing picture", message: "Please insert picture")
            return
        }
        userDataController.saveUserInfo(name: userNameTextField.text!, image: imageView.image!, context: context)
        
        navigationController?.popViewController(animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else{return}
        
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func setUpUser() {
        title = "Edit user"
        if let imageData = activeUser?.picture, let userImage = UIImage(data: imageData) {
            imageView.image = userImage
        }
        userNameTextField.text = activeUser?.name
    }
    
}
