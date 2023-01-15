//
//  FullProfilePictureViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 11/01/23.
//

import UIKit

class FullProfilePictureViewController: UIViewController {

    fileprivate let image = UIImageView()
    public var isCurrentUser = false
    public var uiImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addImageView()
        if isCurrentUser{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(showSimpleActionSheet))
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(offlineTrigger),name: NSNotification.Name("com.user.hasNoConnection"),object: nil)
    }
    
    fileprivate func addImageView(){
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 300).isActive = true
        image.heightAnchor.constraint(equalToConstant: 300).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        image.image = uiImage
    }
    
    @objc func selectProfilePictureFromDefaultAvatars(){
        let nextVC = SelectProfilePictureViewController()
        nextVC.isUpdating = true
        nextVC.email = currentUserAccountObject().email
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func selectFromGallery(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc func offlineTrigger(){
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc  func showSimpleActionSheet(controller: UIViewController) {
            let alert = UIAlertController(title: "Profile Picture Selection", message: "Please Select an Option", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.allowsEditing = true
                vc.delegate = self
                    self.present(vc, animated: true)
            }))

            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
                self.selectFromGallery()
            }))

            alert.addAction(UIAlertAction(title: "Default Avatars", style: .default, handler: { (_) in
                self.selectProfilePictureFromDefaultAvatars()
            }))

            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
                print("User click Dismiss button")
            }))

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FullProfilePictureViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            let img = UIImageView(image: image)
            guard let imageData = img.image?.pngData() else{
                print("failed to update")
                return
            }
            updatingProfileImage(email: currentUserAccountObject().email, data: imageData, completionHandler: {_ in})
        }
        else{
            return
        }
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
}
