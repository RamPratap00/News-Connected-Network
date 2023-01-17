//
//  EditDescriptionViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 12/01/23.
//

import UIKit

class EditDescriptionViewController: UIViewController {

    fileprivate var content = UITextField()
    public var isNavigationControllerNil = false
    fileprivate let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadDescriptionContentEntry()
        addNextButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(offlineTrigger),name: NSNotification.Name("com.user.hasNoConnection"),object: nil)
        if isNavigationControllerNil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(fallBack))
        }
    }
    
    fileprivate func loadDescriptionContentEntry(){
        content.placeholder = " write something 200 characters"
        content.layer.borderWidth = 1
        content.layer.borderColor = UIColor.systemBlue.cgColor
        content.layer.cornerRadius = 20
        content.textAlignment = .center
        content.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(content)
        content.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        content.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        content.widthAnchor.constraint(equalToConstant: 350).isActive = true
        content.heightAnchor.constraint(equalToConstant: 300).isActive = true
        content.delegate = self
    }
    
    fileprivate func addNextButton(){
        nextButton.backgroundColor = .black
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.textAlignment = .center
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        nextButton.setTitleColor(.white, for: .normal)
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.60).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(updateDescription), for: .touchUpInside)
        applyBorderForButton(button: nextButton)
    }
    
    fileprivate func applyBorderForButton(button:UIButton){
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 17
        button.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        button.layer.masksToBounds = true
    }
    
    fileprivate func addWarning(message:String){
        let warningLabel = UILabel()
        warningLabel.text = message
        warningLabel.textAlignment = .center
        warningLabel.textColor = .red
        view.addSubview(warningLabel)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        warningLabel.topAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
    }
    
    @objc func offlineTrigger(){
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc func updateDescription(){
        
        if let description = content.text{
            if content.text!.count > 200{
                addWarning(message: "description too long")
                return
            }
            if description != ""{
                updateProfileDescription(content: description)
                content.text = ""
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func fallBack(){
        self.dismiss(animated: true)
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

extension EditDescriptionViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let description = textField.text{
            if description != ""{
                updateProfileDescription(content: description)
                textField.text = ""
                navigationController?.popViewController(animated: true)
            }
        }
        
        return true
    }
}
