//
//  SelectProfilePictureViewController.swift
//  NCN news app
//
//  Created by ram-16138 on 25/12/22.
//
/// THIS VIEW CONTROLLER IS USED TO RECEIVE USER INPUTS LIKE EMAIL AND PASSWORD FOR SIGNINGUP FOR NEW ACCOUNT
import UIKit
import FirebaseFirestore
import FirebaseStorage

class SelectProfilePictureViewController: UIViewController {
    
    var isFirstVisit = true
    var isUpdating = false
    let quoteForSelectingPicture = UILabel()
    var collectionView : UICollectionView? = nil
    var isImageSelected = false
    var selectedImageIndexPath = IndexPath()
    let nextButton = UIButton()
    var language = String()
    var email = String()
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadBackgroundImageWithText()
        addNextButton()
        addCollectionViewForImageDoodle()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !hasNetworkConnection(){
            self.dismiss(animated: true, completion: nil)
            return
        }
        if !isFirstVisit{
            navigationController?.dismiss(animated: false)
        }
    }
    
    func loadBackgroundImageWithText(){
        let backroundImage = UIImageView(image: UIImage(named: "login Background"))
        view.addSubview(backroundImage)
        backroundImage.contentMode = .scaleToFill
        backroundImage.translatesAutoresizingMaskIntoConstraints = false
        backroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        backroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(quoteForSelectingPicture)
        quoteForSelectingPicture.text = "Every picture tells a story . . ."
        quoteForSelectingPicture.textAlignment = .center
        quoteForSelectingPicture.font = .boldSystemFont(ofSize: 20)
        quoteForSelectingPicture.backgroundColor = .systemBackground
        quoteForSelectingPicture.translatesAutoresizingMaskIntoConstraints = false
        quoteForSelectingPicture.heightAnchor.constraint(equalToConstant: 150).isActive = true
        quoteForSelectingPicture.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 1.01).isActive = true
        quoteForSelectingPicture.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quoteForSelectingPicture.centerYAnchor.constraint(equalTo: backroundImage.bottomAnchor).isActive = true
        quoteForSelectingPicture.layer.cornerRadius = 85
        quoteForSelectingPicture.layer.maskedCorners = [.layerMinXMinYCorner]
        quoteForSelectingPicture.layer.masksToBounds = true
        
    }
    
    func addCollectionViewForImageDoodle(){
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 140, height: 100)
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 5
        collectionViewFlowLayout.sectionInset = .zero
        collectionView = UICollectionView(frame: view.frame,collectionViewLayout: collectionViewFlowLayout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(ProfilePictureCollectionViewCell.self, forCellWithReuseIdentifier: ProfilePictureCollectionViewCell.reusableIdentifier)
        view.addSubview(collectionView!)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.75).isActive = true
        collectionView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: quoteForSelectingPicture.bottomAnchor,constant: -30).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: nextButton.topAnchor,constant: -10).isActive = true
    }

    func addNextButton(){
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
        nextButton.addTarget(self, action: #selector(updatingProfilePicture), for: .touchUpInside)
        applyBorderForButton(button: nextButton)
    }
    
    func applyBorderForButton(button:UIButton){
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 17
        button.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner]
        button.layer.masksToBounds = true
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
            warningLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            warningLabel.topAnchor.constraint(equalTo: collectionView!.topAnchor,constant: -30).isActive = true
    }
    
    @objc func updatingProfilePicture(){
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        if isImageSelected{
            let selectedCell = collectionView?.cellForItem(at: selectedImageIndexPath) as! ProfilePictureCollectionViewCell
            
            if isUpdating{
                updatingProfileImage(email: email, data: (selectedCell.profileImage.image?.pngData()!)!){ updateSatus in
                    if updateSatus{
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
            
            uploadingImageAndLanguageToFireBase(email: email, data: (selectedCell.profileImage.image?.pngData()!)!, language: language){ imageUpdateStatus in
                fetchCurrenUserProfileData(){ _ in
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(true, forKey: "ISLOGGEDIN")
                        self.dismiss(animated: false, completion: nil)
                            let splitView = SplitViewController() // ===> Your splitViewController
                            splitView.modalPresentationStyle = .fullScreen
                            self.present(splitView, animated: true)
                    }
                }
            }
            isFirstVisit = false
        }
        else{
            print("no image selected")
            warning(warningMessage: "No Image selected")
            self.dismiss(animated: false, completion: nil)
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

extension SelectProfilePictureViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePictureCollectionViewCell.reusableIdentifier, for: indexPath) as! ProfilePictureCollectionViewCell
        cell.profileImage.image = UIImage(named: "profile image \(indexPath.row+1)")
        cell.profileImage.layer.borderColor = UIColor.systemBackground.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfilePictureCollectionViewCell
        if cell.cellTapCount%2 == 0{
            if isImageSelected{
                let selectedCell = collectionView.cellForItem(at: selectedImageIndexPath) as! ProfilePictureCollectionViewCell
                selectedCell.profileImage.layer.borderColor = UIColor.systemBackground.cgColor
                selectedCell.cellTapCount+=1
            }
            cell.profileImage.layer.borderWidth = 5
            cell.profileImage.layer.borderColor = UIColor.green.cgColor
            cell.cellTapCount+=1
            isImageSelected = true
            selectedImageIndexPath = indexPath
        }
        else{
            cell.profileImage.layer.borderColor = UIColor.systemBackground.cgColor
            cell.cellTapCount+=1
            isImageSelected = false
        }
    }
}
