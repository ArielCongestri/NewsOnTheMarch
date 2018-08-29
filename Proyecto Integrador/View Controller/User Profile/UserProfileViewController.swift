//
//  UserProfileViewController.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 22/07/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var imagen: UIImageView!
	@IBOutlet var email: UILabel!
    @IBOutlet weak var username: UILabel!
	@IBOutlet weak var editPhoto: UIButton!
	
    let filename = NSUUID().uuidString
    var storageRef : StorageReference!
	var profileImage: UIImage?
    //let storageRef = Storage.storage().reference().child("profile_image").child(filename)
    override func viewDidLoad() {
        super.viewDidLoad()
		setupLogoutButton()
        storageRef = Storage.storage().reference().child("profile_image").child((Auth.auth().currentUser?.uid)!)
        setupView()
		setupImage()
	}
	
	fileprivate func setupImage() {
		imagen.contentMode = .scaleAspectFill
		imagen.layer.cornerRadius = 140 / 2
		imagen.clipsToBounds = true
		imagen.layer.borderColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 0.95).cgColor
		imagen.layer.borderWidth = 3

		editPhoto.layer.cornerRadius = 4
		editPhoto.layer.cornerRadius = 40 / 2
	}

	fileprivate func setupLogoutButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(handleLogout))
		navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 1)
//		(red: 1, green: 218/255, blue: 68/255, alpha: 1)
	}
	
	@objc func handleLogout() {
		print(imagen)
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
			
			do {
				try Auth.auth().signOut()

				
			} catch let signOutError {
				print("Failed to Sign Out: ", signOutError)
			}
			print("perform logut")
//            self.dismiss(animated: true, completion: nil)
//                let loginController = LogInStoryboarViewController()
//                self.present(loginController, animated: true, completion: nil)
			self.performSegue(withIdentifier: "logOut", sender: self)
			
		}))
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		present(alertController,animated: true, completion: nil)
	}
    
    func setupView(){
        let user = Auth.auth().currentUser
        if let userValue = user{
            self.email.text = userValue.email
            self.username.text = userValue.displayName
            if let imageRef = storageRef {
			
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let imageData = data{
                        print("tengo imagen")
						self.imagen.image = UIImage(data: imageData)
						self.imagen.tintColor = UIColor(red: 253/255, green: 203/255, blue: 0/255, alpha: 1)
						
						//self.imagen = image
//                        self.imagen.image = UIImage(data: imageData)
                    }
                }
            }
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? NSDictionary{
                    if let array = dictionary as? [String:AnyObject]{
                        self.username.text = array["username"] as? String
                        
                    }
                }
            }
        }
		print(imagen)
    }
	
	@IBAction func editProfilePicture(_ sender: Any) {
		print(imagen)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            
            let pickerController = UIImagePickerController()
            pickerController.sourceType = .camera
            pickerController.delegate = self
            self.present(pickerController, animated: true, completion: nil)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (_) in
            
            let pickerController = UIImagePickerController()
            pickerController.sourceType = .photoLibrary
            pickerController.delegate = self
            self.present(pickerController, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController,animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			self.profileImage = originalImage
			dismiss(animated: true, completion: nil)
			setAndSaveImage()
		}
	
	}
	func setAndSaveImage() {
		print(imagen)
		imagen.image = profileImage!

		guard let uploadData = UIImageJPEGRepresentation(profileImage!, 0.3) else { return }
		storageRef.putData(uploadData)
	}
	

}
