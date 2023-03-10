//
//  LoginPageViewController.swift
//  NCN news app
//
//  Created by ram-16138 on 24/12/22.
//
/// THIS VIEW CONTROLLER IS USED TO RECEIVE USER INPUTS LIKE EMAIL AND PASSWORD FOR LOGING IN
import UIKit
import FirebaseAuth

class LoginPageViewController: UIViewController {
    fileprivate let scroll = UIScrollView()
    fileprivate let loginLabel = UILabel()
    fileprivate let emailTextField = UITextField()
    fileprivate let passwordTextField = UITextField()
    fileprivate let loginButton = UIButton()
    fileprivate let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    fileprivate let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadBackgroundImageWithText()
        loadEmailPasswordFieldsAndOthers()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(offlineTrigger),name: NSNotification.Name("com.user.hasNoConnection"),object: nil)
       scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
    }
    
    fileprivate func loadBackgroundImageWithText(){
        let backroundImage = UIImageView(image: UIImage(named: "login Background"))
        view.addSubview(backroundImage)
        backroundImage.contentMode = .scaleToFill
        backroundImage.translatesAutoresizingMaskIntoConstraints = false
        backroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        backroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(loginLabel)
        loginLabel.text = "Login"
        loginLabel.textAlignment = .center
        loginLabel.backgroundColor = .systemBackground
        loginLabel.font = .boldSystemFont(ofSize: 40)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        loginLabel.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 1.01).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loginLabel.centerYAnchor.constraint(equalTo: backroundImage.bottomAnchor).isActive = true
        loginLabel.layer.cornerRadius = 85
        loginLabel.layer.maskedCorners = [.layerMinXMinYCorner]
        loginLabel.layer.masksToBounds = true
        
    }
    
    fileprivate func loadEmailPasswordFieldsAndOthers(){
        
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scroll.topAnchor.constraint(greaterThanOrEqualTo: loginLabel.bottomAnchor, constant: 10).isActive = true
        scroll.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scroll.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.5).isActive = true
        scroll.isScrollEnabled = true

        
        let emailLabel = UILabel()
        scroll.addSubview(emailLabel)
        emailLabel.text = "   Email"
        emailLabel.textAlignment = .left
        emailLabel.font = .boldSystemFont(ofSize: 20)
        emailLabel.backgroundColor = .systemBackground
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: scroll.widthAnchor,multiplier: 0.80).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        
        let paddingViewForEmailTextField = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: emailTextField.frame.size.height))
        scroll.addSubview(emailTextField)
        emailTextField.leftView = paddingViewForEmailTextField
        emailTextField.leftViewMode = .always
        emailTextField.placeholder = emailLabel.text
        emailTextField.autocorrectionType = .no
        emailTextField.textAlignment = .left
        emailTextField.font = .systemFont(ofSize: 20)
        emailTextField.backgroundColor = .systemBackground
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: scroll.widthAnchor,multiplier: 0.80).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(greaterThanOrEqualTo: emailLabel.bottomAnchor, constant: 2).isActive = true
        emailTextField.delegate = self
        applyBorderForTextField(textField: emailTextField)
        
        let passwordLabel = UILabel()
        scroll.addSubview(passwordLabel)
        passwordLabel.text = "   Password"
        passwordLabel.textAlignment = .left
        passwordLabel.font = .boldSystemFont(ofSize: 20)
        passwordLabel.backgroundColor = .systemBackground
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        passwordLabel.widthAnchor.constraint(equalTo: scroll.widthAnchor,multiplier: 0.80).isActive = true
        passwordLabel.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant: 25).isActive = true
        
        let paddingViewForPasswordTextField = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: emailTextField.frame.size.height))
        scroll.addSubview(passwordTextField)
        passwordTextField.leftView = paddingViewForPasswordTextField
        passwordTextField.leftViewMode = .always
        passwordTextField.placeholder = passwordLabel.text
        passwordTextField.textAlignment = .left
        passwordTextField.font = .systemFont(ofSize: 20)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = .systemBackground
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: scroll.widthAnchor,multiplier: 0.80).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(greaterThanOrEqualTo: passwordLabel.bottomAnchor, constant: 2).isActive = true
        passwordTextField.delegate = self
        applyBorderForTextField(textField: passwordTextField)
        
        loginButton.backgroundColor = .black
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.textAlignment = .center
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        loginButton.setTitleColor(.white, for: .normal)
        scroll.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.80).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 30).isActive = true
        loginButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        loginButton.addTarget(self, action: #selector(loginCheck), for: .touchUpInside)
        applyBorderForButton(button: loginButton)
        
        
        let newAccountMessageLabel = UILabel()
        newAccountMessageLabel.text = "Don't have any account?"
        newAccountMessageLabel.font = .boldSystemFont(ofSize: 15)
        scroll.addSubview(newAccountMessageLabel)
        newAccountMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        newAccountMessageLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        newAccountMessageLabel.widthAnchor.constraint(equalToConstant: 190).isActive = true
        newAccountMessageLabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor).isActive = true
        newAccountMessageLabel.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor,constant: 100).isActive = true
        
        let signUpButton = UIButton()
        signUpButton.setTitle("SignUp", for: .normal)
        signUpButton.titleLabel?.textAlignment = .left
        signUpButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        signUpButton.setTitleColor(.gray, for: .normal)
        scroll.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.centerYAnchor.constraint(equalTo: newAccountMessageLabel.centerYAnchor).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: newAccountMessageLabel.trailingAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpButton.addTarget(self, action: #selector(pushSignUpViewController), for: .touchUpInside)
        
    }

    @objc func pushSignUpViewController(){
        let nextVC = SignUpViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func loginCheck(){
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        /// fire base login
        login(email: email, password: password){ loginStatus in
            if loginStatus {
                UserDefaults.standard.set(email, forKey: "EMAIL")
                DispatchQueue.main.async {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    self.dismiss(animated: false, completion: nil)
                    
                    let splitView = SplitViewController() // ===> Your splitViewController
                    splitView.modalPresentationStyle = .fullScreen
                    self.present(splitView, animated: true)
                }
            }
            else{
                self.dismiss(animated: false, completion: nil)
                self.passwordTextField.layer.borderColor = UIColor.red.cgColor
                self.emailTextField.layer.borderColor = UIColor.red.cgColor
                self.warning(warningMessage: "Invalid UserName/Password")
            }
        }
    }
    
    @objc func offlineTrigger(){
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
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

extension LoginPageViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        warning(warningMessage: "")
        textField.resignFirstResponder()
        loginCheck()
        
        return true
    }
    
    fileprivate func warning(warningMessage:String){
        let warningLabel = UILabel()
            warningLabel.text = warningMessage
            warningLabel.textColor = .red
            warningLabel.textAlignment = .center
            warningLabel.backgroundColor = .systemBackground
            view.addSubview(warningLabel)
            warningLabel.translatesAutoresizingMaskIntoConstraints = false
            warningLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            warningLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            warningLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor,constant: 10).isActive = true
    }
    
}
