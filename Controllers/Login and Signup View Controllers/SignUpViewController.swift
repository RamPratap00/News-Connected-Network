//
//  SignUpViewController.swift
//  NCN news app
//
//  Created by ram-16138 on 25/12/22.
//
/// THIS VIEW CONTROLLER IS USED TO RECEIVE USER INPUTS LIKE EMAIL AND PASSWORD FOR SIGNINGUP FOR NEW ACCOUNT
import UIKit

class SignUpViewController: UIViewController {

    let scroll = UIScrollView()
    let signUpLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let userNameField = UITextField()
    let confirmPasswordTextField = UITextField()
    let signUpButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadBackgroundImageWithText()
        loadUserNamePasswordFieldsAndOthers()
        // Do any additional setup after loading the view.
    }
    // Fix scroll content size
    override func viewDidAppear(_ animated: Bool) {
        if !hasNetworkConnection(){
            self.dismiss(animated: true, completion: nil)
            return
        }
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.8)
    }
    /// this function is used to load the black and white galaxy picture with the text "signup" just below it
    func loadBackgroundImageWithText(){
        
        let backroundImage = UIImageView(image: UIImage(named: "login Background"))
        view.addSubview(backroundImage)
        backroundImage.contentMode = .scaleToFill
        backroundImage.translatesAutoresizingMaskIntoConstraints = false
        backroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        backroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(signUpLabel)
        signUpLabel.text = "Sign Up"
        signUpLabel.textAlignment = .center
        signUpLabel.font = .boldSystemFont(ofSize: 40)
        signUpLabel.backgroundColor = .systemBackground
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        signUpLabel.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 1.01).isActive = true
        signUpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        signUpLabel.centerYAnchor.constraint(equalTo: backroundImage.bottomAnchor).isActive = true
        signUpLabel.layer.cornerRadius = 85
        signUpLabel.layer.maskedCorners = [.layerMinXMinYCorner]
        signUpLabel.layer.masksToBounds = true
        
    }
    /// this function is used to load the email/password label and text filed and other fields for creating new account
    func loadUserNamePasswordFieldsAndOthers(){
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scroll.topAnchor.constraint(greaterThanOrEqualTo: signUpLabel.bottomAnchor, constant: 10).isActive = true
        scroll.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scroll.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.6).isActive = true
        
        scroll.isScrollEnabled = true

        let paddingViewForUserNameField = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: emailTextField.frame.size.height))
        
        let userNameLabel = UILabel()
        scroll.addSubview(userNameLabel)
        userNameLabel.text = "   Full Name"
        userNameLabel.textAlignment = .left
        userNameLabel.font = .boldSystemFont(ofSize: 20)
        userNameLabel.backgroundColor = .systemBackground
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        userNameLabel.widthAnchor.constraint(equalTo: scroll.widthAnchor,multiplier: 0.80).isActive = true
        userNameLabel.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        
        scroll.addSubview(userNameField)
        userNameField.leftView = paddingViewForUserNameField
        userNameField.leftViewMode = .always
        userNameField.placeholder = userNameLabel.text
        userNameField.textAlignment = .left
        userNameField.font = .systemFont(ofSize: 20)
        userNameField.backgroundColor = .systemBackground
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userNameField.widthAnchor.constraint(equalTo: scroll.widthAnchor,multiplier: 0.80).isActive = true
        userNameField.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        userNameField.topAnchor.constraint(greaterThanOrEqualTo: userNameLabel.bottomAnchor, constant: 2).isActive = true
        applyBorderForTextField(textField: userNameField)
        userNameField.delegate = self
        
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
        emailLabel.topAnchor.constraint(equalTo: userNameField.bottomAnchor,constant: 25).isActive = true
        
        
        let paddingViewForEmailTextField = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: emailTextField.frame.size.height))
        scroll.addSubview(emailTextField)
        emailTextField.leftView = paddingViewForEmailTextField
        emailTextField.leftViewMode = .always
        emailTextField.placeholder = emailLabel.text
        emailTextField.textAlignment = .left
        emailTextField.autocorrectionType = .no
        emailTextField.font = .systemFont(ofSize: 20)
        emailTextField.backgroundColor = .systemBackground
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: scroll.widthAnchor,multiplier: 0.80).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(greaterThanOrEqualTo: emailLabel.bottomAnchor, constant: 2).isActive = true
        applyBorderForTextField(textField: emailTextField)
        emailTextField.delegate = self
        
        
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
        
        let paddingViewForPasswordTextField = UIView(frame: CGRect(x: 0, y: 0, width: 15, height:emailTextField.frame.size.height))
        scroll.addSubview(passwordTextField)
        passwordTextField.leftView = paddingViewForPasswordTextField
        passwordTextField.leftViewMode = .always
        passwordTextField.placeholder = passwordLabel.text
        passwordTextField.textAlignment = .left
        passwordTextField.font = .systemFont(ofSize: 20)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.backgroundColor = .systemBackground
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: scroll.widthAnchor,multiplier: 0.80).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(greaterThanOrEqualTo: passwordLabel.bottomAnchor, constant: 2).isActive = true
        applyBorderForTextField(textField: passwordTextField)
        passwordTextField.delegate = self
        
        let confirmPasswordLabel = UILabel()
        scroll.addSubview(confirmPasswordLabel)
        confirmPasswordLabel.text = "  Confirm Password"
        confirmPasswordLabel.textAlignment = .left
        confirmPasswordLabel.font = .boldSystemFont(ofSize: 20)
        confirmPasswordLabel.backgroundColor = .systemBackground
        confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        confirmPasswordLabel.widthAnchor.constraint(equalTo: scroll.widthAnchor,multiplier: 0.80).isActive = true
        confirmPasswordLabel.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 25).isActive = true
        
        let paddingViewForConfirmPasswordTextField = UIView(frame: CGRect(x: 0, y: 0, width: 15, height:emailTextField.frame.size.height))
        scroll.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.leftView = paddingViewForConfirmPasswordTextField
        confirmPasswordTextField.leftViewMode = .always
        confirmPasswordTextField.placeholder = confirmPasswordLabel.text
        confirmPasswordTextField.textAlignment = .left
        confirmPasswordTextField.font = .systemFont(ofSize: 20)
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.autocorrectionType = .no
        confirmPasswordTextField.backgroundColor = .systemBackground
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmPasswordTextField.widthAnchor.constraint(equalTo: scroll.widthAnchor,multiplier: 0.80).isActive = true
        confirmPasswordTextField.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        confirmPasswordTextField.topAnchor.constraint(greaterThanOrEqualTo: confirmPasswordLabel.bottomAnchor, constant: 2).isActive = true
        applyBorderForTextField(textField: confirmPasswordTextField)
        confirmPasswordTextField.delegate = self
        
        signUpButton.backgroundColor = .black
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.textAlignment = .center
        signUpButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        signUpButton.setTitleColor(.white, for: .normal)
        scroll.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.80).isActive = true
        signUpButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor,constant: 30).isActive = true
        signUpButton.heightAnchor.constraint(equalTo: confirmPasswordTextField.heightAnchor).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        signUpButton.addTarget(self, action: #selector(pushSelectProfilePictureViewController), for: .touchUpInside)
        applyBorderForButton(button: signUpButton)
        
        
        let newAccountMessageLabel = UILabel()
        newAccountMessageLabel.text = "Already have any account?"
        newAccountMessageLabel.font = .boldSystemFont(ofSize: 15)
        scroll.addSubview(newAccountMessageLabel)
        newAccountMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        newAccountMessageLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        newAccountMessageLabel.widthAnchor.constraint(equalToConstant: 210).isActive = true
        newAccountMessageLabel.leadingAnchor.constraint(equalTo: signUpButton.leadingAnchor).isActive = true
        newAccountMessageLabel.bottomAnchor.constraint(equalTo: signUpButton.bottomAnchor,constant: 100).isActive = true
        
        let signInButton = UIButton()
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.textAlignment = .left
        signInButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        signInButton.setTitleColor(.gray, for: .normal)
        scroll.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerYAnchor.constraint(equalTo: newAccountMessageLabel.centerYAnchor).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: newAccountMessageLabel.trailingAnchor).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInButton.addTarget(self, action: #selector(popSignUpViewController), for: .touchUpInside)
        
    }
    
    func warning(warningMessage:String){
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
            warningLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor,constant: 10).isActive = true
    }

    func applyBorderForButton(button:UIButton){
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 17
        button.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        button.layer.masksToBounds = true
    }
    
    func applyBorderForTextField(textField:UITextField){
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 17
        textField.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        textField.layer.masksToBounds = true
    }
    
    func isValidEmail(email: String) -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailPred.evaluate(with: email)
    }
    
    @objc func pushSelectProfilePictureViewController(){
            var _ = textFieldShouldReturn(passwordTextField)
    }
    
    @objc func popSignUpViewController(){
        navigationController?.popViewController(animated: true)
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

extension SignUpViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        warning(warningMessage: "")
        if confirmPasswordTextField.text != passwordTextField.text{
            userNameField.layer.borderColor = UIColor.gray.cgColor
            emailTextField.layer.borderColor = UIColor.gray.cgColor
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
            warning(warningMessage: "Password Mismatch")
            return true
        }
        checkAllDataRequirementAndUploadToFireBase(email: emailTextField.text,
                                         password: passwordTextField.text,
                                         userName: userNameField.text){ warningText in
            warning(warningMessage: warningText)
        }
        return true
    }
    
    func checkAllDataRequirementAndUploadToFireBase(email:String?,password:String?,userName:String?,warningCompletionHandler:(String)->()){
        if password == "" || userName == "" || email == ""{
            warningCompletionHandler("one or more data missing")
            if password == ""{
                userNameField.layer.borderColor = UIColor.gray.cgColor
                emailTextField.layer.borderColor = UIColor.gray.cgColor
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
            }
            if userName == ""{
                userNameField.layer.borderColor = UIColor.red.cgColor
                emailTextField.layer.borderColor = UIColor.gray.cgColor
                passwordTextField.layer.borderColor = UIColor.gray.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.gray.cgColor
            }
            if email == ""{
                userNameField.layer.borderColor = UIColor.gray.cgColor
                emailTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.borderColor = UIColor.gray.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.gray.cgColor
            }
            if email == "" && password == ""{
                userNameField.layer.borderColor = UIColor.gray.cgColor
                emailTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
            }
            if email == "" && userName == ""{
                userNameField.layer.borderColor = UIColor.red.cgColor
                emailTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.borderColor = UIColor.gray.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.gray.cgColor
            }
            if email == "" && userName == "" && password == ""{
                userNameField.layer.borderColor = UIColor.red.cgColor
                emailTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
            }
            return
        }
        
        if !ENCDEC.isStrongPassword(password: password!) || !isValidEmail(email: email!){
            if userNameField.text!.count > 30{
                warningCompletionHandler("user name too long")
            }
            if !ENCDEC.isStrongPassword(password: password!){
                emailTextField.layer.borderColor = UIColor.gray.cgColor
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
                warningCompletionHandler("weak password")
            }
            if !isValidEmail(email: email!){
                emailTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.borderColor = UIColor.gray.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.gray.cgColor
                warningCompletionHandler("invalid email")
            }
            if !ENCDEC.isStrongPassword(password: password!) && !isValidEmail(email: email!){
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
                emailTextField.layer.borderColor = UIColor.red.cgColor
                warningCompletionHandler("invalid email and weak password")
            }
            return
        }
        /// fire base signup
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        uploadDefaultUserDataToFireBase(email: email!, password: password!, userName: userName!){ status,encryptedEmail in
                DispatchQueue.main.async{
                    if status {
                        UserDefaults.standard.set(email!, forKey: "EMAIL")
                        let nextVC = SelectLanguageViewController()
                        nextVC.email = email!
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                    else{
                        self.warning(warningMessage: "user already exist")
                    }
                    self.dismiss(animated: false, completion: nil)
                }
            }
    }
    
    
    
}

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
