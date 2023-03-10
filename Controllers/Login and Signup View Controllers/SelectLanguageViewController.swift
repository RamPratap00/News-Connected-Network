//
//  SelectLanguageViewController.swift
//  News Connected Network
//
//  Created by ram-16138 on 08/01/23.
//

import UIKit
import Firebase
import FirebaseStorage

class SelectLanguageViewController: UIViewController {

    
    fileprivate var isFirstVisit = true
    fileprivate let quoteForSelectingLanguage = UILabel()
    fileprivate var collectionView : UICollectionView? = nil
    fileprivate var isImageSelected = false
    fileprivate var selectedImageIndexPath = IndexPath()
    fileprivate let nextButton = UIButton()
    public var email = String()
    fileprivate let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    fileprivate let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadBackgroundImageWithText()
        addNextButton()
        addCollectionViewForLanguage()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(offlineTrigger),name: NSNotification.Name("com.user.hasNoConnection"),object: nil)
    }
    
    fileprivate func loadBackgroundImageWithText(){
        let backroundImage = UIImageView(image: UIImage(named: "login Background"))
        view.addSubview(backroundImage)
        backroundImage.contentMode = .scaleToFill
        backroundImage.translatesAutoresizingMaskIntoConstraints = false
        backroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        backroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(quoteForSelectingLanguage)
        quoteForSelectingLanguage.text = "Select your prefered langauge . . ."
        quoteForSelectingLanguage.textAlignment = .center
        quoteForSelectingLanguage.font = .boldSystemFont(ofSize: 20)
        quoteForSelectingLanguage.backgroundColor = .systemBackground
        quoteForSelectingLanguage.translatesAutoresizingMaskIntoConstraints = false
        quoteForSelectingLanguage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        quoteForSelectingLanguage.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 1.01).isActive = true
        quoteForSelectingLanguage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quoteForSelectingLanguage.centerYAnchor.constraint(equalTo: backroundImage.bottomAnchor).isActive = true
        quoteForSelectingLanguage.layer.cornerRadius = 85
        quoteForSelectingLanguage.layer.maskedCorners = [.layerMinXMinYCorner]
        quoteForSelectingLanguage.layer.masksToBounds = true
        
    }
    
    fileprivate func addCollectionViewForLanguage(){
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 120, height: 120)
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 5
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        collectionView = UICollectionView(frame: view.frame,collectionViewLayout: collectionViewFlowLayout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(SelectLanguageCollectionViewCell.self, forCellWithReuseIdentifier: SelectLanguageCollectionViewCell.reusableIdentifier)
        view.addSubview(collectionView!)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.80).isActive = true
        collectionView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: quoteForSelectingLanguage.bottomAnchor,constant: -30).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: nextButton.topAnchor,constant: -10).isActive = true
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
        nextButton.addTarget(self, action: #selector(updatingLanguagePreference), for: .touchUpInside)
        applyBorderForButton(button: nextButton)
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
            warningLabel.topAnchor.constraint(equalTo: collectionView!.topAnchor).isActive = true
    }
    
    @objc func updatingLanguagePreference(){
        if isImageSelected{
            let selectedCell = collectionView?.cellForItem(at: selectedImageIndexPath) as! SelectLanguageCollectionViewCell
            let nextVC = SelectProfilePictureViewController()
            nextVC.email = self.email
            nextVC.language = selectedCell.languageLabel.text!
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else{
            warning(warningMessage: "No Language Selected")
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


extension SelectLanguageViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return langauge.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectLanguageCollectionViewCell.reusableIdentifier, for: indexPath) as! SelectLanguageCollectionViewCell
        cell.languageLabel.text = langauge[indexPath.row]
        cell.languageLabel.textAlignment = .center
        cell.languageLabel.font = .boldSystemFont(ofSize: 20)
        cell.languageLabel.layer.borderColor = UIColor.systemBackground.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SelectLanguageCollectionViewCell
        
        if cell.cellTapCount%2 == 0{
            if isImageSelected{
                let selectedCell = collectionView.cellForItem(at: selectedImageIndexPath) as! SelectLanguageCollectionViewCell
                selectedCell.languageLabel.layer.borderColor = UIColor.systemBackground.cgColor
                selectedCell.cellTapCount+=1
            }
            cell.languageLabel.layer.borderWidth = 5
            cell.languageLabel.layer.borderColor = UIColor.green.cgColor
            cell.cellTapCount+=1
            isImageSelected = true
            selectedImageIndexPath = indexPath
        }
        else{
            cell.languageLabel.layer.borderColor = UIColor.systemBackground.cgColor
            cell.cellTapCount+=1
            isImageSelected = false
        }
        
    }
}
