//
//  ViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 28/12/22.
//
/// THIS VIEW CONTROLLER IS THE ROOT OF ALL VIEW CONTROLLERS AND IT IS USED TO MAKE API CALLS DB CALLS AND DISPLAY THE LOGO OF THE NEWS APP
import UIKit

class SplashViewController: UIViewController {

    var isFirstVisit = true
    override func viewDidLoad() {
        super.viewDidLoad()
        displayNcnLogo()
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.moveToLoginPage()
        }
        createDataBase()
        //eraseDataBase()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isFirstVisit{
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.moveToLoginPage()
            }
        }
    }

    // MARK: - This function is used to display the news app logo
    func displayNcnLogo(){
        
        let image = UIImageView(image: UIImage(named: "appstore"))
        let imageDimension = CGFloat(200)
        view.addSubview(image)
        // image configuration
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: imageDimension).isActive = true
        image.heightAnchor.constraint(equalToConstant: imageDimension).isActive = true
        image.layer.masksToBounds = true
        image.layer.cornerRadius = imageDimension/2
    }
    // MARK: - funtions to call api and db
    
    func createDataBase(){
        DispatchQueue.global(qos: .background).async {
            let userDataBase = GlobalUserAccountDataBaseManager(dataBaseName: "UserAccountDataBase")
            userDataBase.closeDataBase()
        }
    }
    func eraseDataBase(){
        DispatchQueue.global(qos: .background).async {
            let userDataBase = GlobalUserAccountDataBaseManager(dataBaseName: "UserAccountDataBase")
            userDataBase.eraseDataBase()
            userDataBase.closeDataBase()
        }
    }
    
    // MARK: - This function is used to initiate Navigation controller and auto push to next View Controller
    func moveToLoginPage(){
        let rootVC = LoginPageViewController()
        isFirstVisit = false
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

}

