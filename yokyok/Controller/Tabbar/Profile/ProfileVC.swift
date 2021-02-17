//
//  ProfileVC.swift
//  yokyok
//
//  Created by Nazik on 12.02.2021.
//

import UIKit
import SDWebImage

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tabbarView: UIView!

    @IBOutlet weak var tabbarMainPageView: UIView!
    @IBOutlet weak var tabbarCategoriesView: UIView!
    @IBOutlet weak var tabbarMyFavouriteView: UIView!
    @IBOutlet weak var tabbarMyProfileView: UIView!
    
    @IBOutlet weak var myAddressesView: UIView!
    @IBOutlet weak var paymentMethodsView: UIView!
    @IBOutlet weak var previousOrdersView: UIView!
    @IBOutlet weak var securitySettingsView: UIView!
    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var supportLineView: UIView!
    @IBOutlet weak var aboutUsView: UIView!
    @IBOutlet weak var signOutView: UIView!
    
    var photo = ""
    var nameSurname = ""
    var email = ""
    var phone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayouts()
        
        //MARK:- GESTURE RECOGNIZER
        addGestureRecognizer(view: tabbarCategoriesView)
        addGestureRecognizer(view: tabbarMyFavouriteView)
        addGestureRecognizer(view: tabbarMainPageView)
        
        addGestureRecognizer(view: myAddressesView)
        addGestureRecognizer(view: paymentMethodsView)
        addGestureRecognizer(view: previousOrdersView)
        addGestureRecognizer(view: securitySettingsView)
        addGestureRecognizer(view: inviteView)
        addGestureRecognizer(view: supportLineView)
        addGestureRecognizer(view: aboutUsView)
        addGestureRecognizer(view: signOutView)
        
        getUser()
        
    }
    
    func addGestureRecognizer(view: UIView) {
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gestureRecognizerMethods(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func gestureRecognizerMethods(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case tabbarMainPageView:
            let vc = self.storyboard?.instantiateViewController(identifier: "MainPageVC") as! MainPageVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        case tabbarCategoriesView:
            let vc = self.storyboard?.instantiateViewController(identifier: "CategoriesVC") as! CategoriesVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        case tabbarMyFavouriteView:
            let vc = self.storyboard?.instantiateViewController(identifier: "FavouriteProductsVC") as! FavouriteProductsVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        case myAddressesView:
            let vc = self.storyboard?.instantiateViewController(identifier: "MyAddressedVC") as! MyAddressedVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case paymentMethodsView:
            print("")
//            let vc = self.storyboard?.instantiateViewController(identifier: "MyAddressedVC") as! MyAddressedVC
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
        case previousOrdersView:
            let vc = self.storyboard?.instantiateViewController(identifier: "PreviousOrdersVC") as! PreviousOrdersVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case securitySettingsView:
            let vc = self.storyboard?.instantiateViewController(identifier: "SecuritySettingsVC") as! SecuritySettingsVC
            vc.photo = photo
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case supportLineView:
            let vc = self.storyboard?.instantiateViewController(identifier: "SupportLineVC") as! SupportLineVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case aboutUsView:
            let vc = self.storyboard?.instantiateViewController(identifier: "AboutUsVC") as! AboutUsVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case signOutView:
                let vc = SignOutPopup(nibName: "SignOutPopup", bundle: nil)
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false, completion: nil)
        case inviteView:
            
            let url = URL(string: "https://apps.apple.com/us/app/id1535629801")!
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(vc, animated: true)
        default:
            break
        }
    }
    
    func setupLayouts() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        tabbarView.backgroundColor = UIColor.white
        tabbarView.layer.borderWidth = 1
        tabbarView.layer.borderColor = UIColor.lightGray.cgColor
    }

    
    @IBAction func myCartTabbarButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "MyCartVC") as! MyCartVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func editProfileButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "EditProfileVC") as! EditProfileVC
        vc.nameSurname = nameSurname
        vc.email = email
        vc.phone = phone
        vc.photo = photo
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //MARK:- NETWORKING
    func getUser() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "user")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        // Set HTTP Request Header
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
            
            guard let data = data else {return}
            
            do{
                
                let userProfileResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)

                if userProfileResponse.status{
                    DispatchQueue.main.async { [self] in
                        self.nameSurnameLabel.text = userProfileResponse.data?.name
                        nameSurname = (userProfileResponse.data?.name)!
                        self.emailLabel.text = userProfileResponse.data?.email
                        email = (userProfileResponse.data?.email)!
                        self.phoneNumberLabel.text = userProfileResponse.data?.phone
                        phone = (userProfileResponse.data?.phone)!
                        self.profileImageView.sd_setImage(with: URL(string: BaseURL.USER_IMAGE_URL + "\(userProfileResponse.data?.photo ?? "default.jpeg")"), completed: nil)
                        self.photo = (userProfileResponse.data?.photo)!
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.removeViewsForAnimation()
                        let alert = UIAlertController(title: "Hata", message: userProfileResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)

                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }catch let jsonError{
                print("User Profile Response = \(jsonError)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    //self.removeViewsForAnimation()
                    let alert = UIAlertController(title: "Hata", message: "Sunucu Hatası", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    
}
