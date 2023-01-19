//
//  ViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 28/12/22.
//
/// THIS VIEW CONTROLLER IS THE ROOT OF ALL VIEW CONTROLLERS AND IT IS USED TO MAKE API CALLS DB CALLS AND DISPLAY THE LOGO OF THE NEWS APP
import UIKit

class SplashViewController: UIViewController {

    fileprivate var isFirstVisit = true
    fileprivate let network = NetworkMonitor()
    fileprivate let warningImageViewForNoInternet = UIImageView()
    fileprivate let offlineMode = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNcnLogo()
        NotificationCenter.default.addObserver(self,selector: #selector(initiateViewNavigationAfterComingBackOnline),name: NSNotification.Name("com.user.hasConnection"),object: nil)
        network.startMonitoring()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if navigationController != nil{
            navigationController?.dismiss(animated: false)
        }
        if hasNetworkConnection(){
            view.backgroundColor = .systemGreen
            //dataBasePopulator()
            viewNavigator()
        }
        else{
            view.backgroundColor = .systemRed
            switchToNoInternetMode()
        }
        
    }

    // MARK: - This function is used to display the news app logo
    
    fileprivate func showNcnLogo(){
        
        let ncnImageView = UIImageView(image: UIImage(named: "appstore"))
        let imageDimension = CGFloat(200)
        view.addSubview(ncnImageView)
        // image configuration
        ncnImageView.translatesAutoresizingMaskIntoConstraints = false
        ncnImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ncnImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        ncnImageView.widthAnchor.constraint(equalToConstant: imageDimension).isActive = true
        ncnImageView.heightAnchor.constraint(equalToConstant: imageDimension).isActive = true
        ncnImageView.layer.masksToBounds = true
        ncnImageView.layer.cornerRadius = imageDimension/2
    }
    
    // MARK: - funtions to call api and db

    fileprivate func dataBasePopulator(){
        let populator = NewsDataBasePopulator()
        populator.refillDataBaseForOfflineMode()
    }
    
    // MARK: - This set of functions is used to initiate Navigation controller and auto push to next View Controller
    
    fileprivate func goToLoginPage(){
        let rootVC = LoginPageViewController()
        isFirstVisit = false
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    fileprivate func skipLoginPage(){
        dataBasePopulator()
        fetchUserProfileData(isCurrentUser: true, email: currentLoggedInUserAccount().email ){ _ in
            DispatchQueue.main.async{
                
                let splitView = SplitViewController() // ===> Your splitViewController
                splitView.modalPresentationStyle = .fullScreen
                    self.present(splitView, animated: true)
            }
        }
        
    }
    
    fileprivate func viewNavigator(){
        if UserDefaults.standard.bool(forKey: "ISLOGGEDIN"){
            skipLoginPage()
        }
        else{
            let seconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
                self.goToLoginPage()
            }
        }
    }
    
    @objc func initiateViewNavigationAfterComingBackOnline(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.warningImageViewForNoInternet.removeFromSuperview()
            self.offlineMode.removeFromSuperview()
            self.view.backgroundColor = .systemGreen
            if UserDefaults.standard.bool(forKey: "ISLOGGEDIN"){
                self.skipLoginPage()
            }
            else{
                self.goToLoginPage()
            }
        }
    }
    
    // MARK: - Fetches news data from local storage
    
    fileprivate  func switchToNoInternetMode(){
        warningImageViewForNoInternet.image = UIImage(systemName: "wifi.exclamationmark")
        warningImageViewForNoInternet.tintColor = .yellow
        view.addSubview(warningImageViewForNoInternet)
        warningImageViewForNoInternet.translatesAutoresizingMaskIntoConstraints = false
        warningImageViewForNoInternet.widthAnchor.constraint(equalToConstant: 30).isActive = true
        warningImageViewForNoInternet.heightAnchor.constraint(equalToConstant: 30).isActive = true
        warningImageViewForNoInternet.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningImageViewForNoInternet.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -150).isActive = true
        
        offlineMode.setTitle("Switch to offline mode", for: .normal)
        offlineMode.tintColor = .systemGreen
        view.addSubview(offlineMode)
        offlineMode.translatesAutoresizingMaskIntoConstraints = false
        offlineMode.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        offlineMode.heightAnchor.constraint(equalToConstant: 50).isActive = true
        offlineMode.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        offlineMode.topAnchor.constraint(equalTo: warningImageViewForNoInternet.bottomAnchor).isActive = true
        offlineMode.addTarget(self, action: #selector(showNewsInOfflineMode), for: .touchUpInside)
    }
    
    @objc func showNewsInOfflineMode(){
        let rootVC = NewsFeedViewController()
        rootVC.isOfflineMode = true
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
}

