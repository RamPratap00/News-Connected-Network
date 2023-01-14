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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if hasNetworkConnection(){
            view.backgroundColor = .systemGreen
            viewNavigator()
        }
        else{
            view.backgroundColor = .systemRed
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

    
    // MARK: - This function is used to initiate Navigation controller and auto push to next View Controller
    func moveToLoginPage(){
        let rootVC = LoginPageViewController()
        isFirstVisit = false
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func skipLoginPage(){
        
        fetchCurrenUserProfileData(){ _ in
            DispatchQueue.main.async{
                
                let splitView = SplitViewController() // ===> Your splitViewController
                splitView.modalPresentationStyle = .fullScreen
                    self.present(splitView, animated: true)
            }
        }
        
    }

    func viewNavigator(){
        if UserDefaults.standard.bool(forKey: "ISLOGGEDIN"){
            skipLoginPage()
        }
        else{
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
                self.moveToLoginPage()
            }
        }
    }
    
}

func createSpinnerFooter(view:UIView) -> UIView {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
     let spinner = UIActivityIndicatorView()
    spinner.center = footerView.center
    footerView.addSubview(spinner)
    return footerView
}
