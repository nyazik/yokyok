//
//  EditProfileVC.swift
//  yokyok
//
//  Created by Nazik on 14.02.2021.
//

import UIKit
import SDWebImage

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var securitySettingsView: UIView!
    @IBOutlet weak var photoBackgroundView: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var nameSurnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var photo = ""
    var nameSurname = ""
    var email = ""
    var phone = ""
    
    var textFields: [UITextField] {
        return [nameSurnameTextField, emailTextField, phoneTextField]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        hideKeyboardWhenTappedAround()
        textFields.forEach {$0.delegate = self}
        
        addGestureRecognizer(view: photoBackgroundView)
        print("**\(photo)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    func addGestureRecognizer(view: UIView) {
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gestureRecognizerMethods(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func gestureRecognizerMethods(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case photoBackgroundView:
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                let imagePicker = UIImagePickerController()
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = true
                    present(imagePicker, animated: true, completion: nil)
                }
            }
        default:
            break
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profilePhotoImageView.image = image
        }
        
    }
    
    
    @IBAction func updateUserButtonPressed(_ sender: UIButton) {
        if nameSurnameTextField.text != "" && emailTextField.text != "" && phoneTextField.text != "" {
            addPhoto(imageView: profilePhotoImageView, param: ["name": "\(self.nameSurnameTextField.text!)", "email": "\(self.emailTextField.text!)", "phone": "\(self.phoneTextField.text!)"])
        } else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen gerekli alanları doldurunuz.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func setupLayouts() {
        securitySettingsView.layer.cornerRadius = 10
        securitySettingsView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        securitySettingsView.backgroundColor = UIColor.white
        
        photoBackgroundView.layer.cornerRadius = photoBackgroundView.frame.height / 2
        photoBackgroundView.backgroundColor = UIColor.white
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.height / 2
        
        nameSurnameTextField.layer.cornerRadius = nameSurnameTextField.frame.height / 2
        nameSurnameTextField.setLeftPaddingPoints(10)
        nameSurnameTextField.setRightPaddingPoints(10)
        
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        emailTextField.setLeftPaddingPoints(10)
        emailTextField.setRightPaddingPoints(10)
        
        phoneTextField.layer.cornerRadius = phoneTextField.frame.height / 2
        phoneTextField.setLeftPaddingPoints(10)
        phoneTextField.setRightPaddingPoints(10)
        
        profilePhotoImageView.sd_setImage(with: URL(string: BaseURL.USER_IMAGE_URL + "\(photo ?? "default.jpeg")"), completed: nil)
        
        nameSurnameTextField.text = nameSurname
        emailTextField.text = email
        phoneTextField.text = phone
    }

  
    @IBAction func backButttonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- NETWORKING
    func addPhoto(imageView: UIImageView, param: [String:String]?) {
        
        //addViewsForAnimation()
        
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "user")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        
        request.httpMethod = "POST"
    
        // Set HTTP Request Header
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = imageView.image!.jpegData(compressionQuality: 0.2)
        
        if(imageData == nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "photo", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        //myActivityIndicator.startAnimating();
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let data = data {
                
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("**\(responseString)")
                
                if responseString!.contains("true") {
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileVC
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        //self.dismiss(animated: true, completion: nil)
                        //NotificationCenter.default.post(name: .addedPhoto, object: nil)
                        //self.removeViewsForAnimation()
                    }
                } else {
                    DispatchQueue.main.async {
                        //self.removeViewsForAnimation()
                        
                        let alert = UIAlertController(title: "Hata", message: "Bilgileriniz güncellenirken bir hata oluştu. Lütfen tekrar deneyiniz.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                
            } else if let error = error {
                print(error)
                //self.removeViewsForAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let alert = UIAlertController(title: "Hata", message: "Sunucu Hatası", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Tamam", style: .default) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        task.resume()
        
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}



extension SecuritySettingsVC  : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let selectedTextFieldIndex = textFields.firstIndex(of: textField), selectedTextFieldIndex < textFields.count - 1 {
            textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder() // last textfield, dismiss keyboard directly
        }
        return true
    }
}


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
    
}
