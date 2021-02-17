//
//  SecuritySettingsVC.swift
//  yokyok
//
//  Created by Nazik on 14.02.2021.
//

import UIKit

class SecuritySettingsVC: UIViewController {
    
    @IBOutlet weak var securitySettingsView: UIView!
    @IBOutlet weak var photoBackgroundView: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var previousPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    var photo = ""
    
    var textFields: [UITextField] {
        return [previousPasswordTextField, newPasswordTextField, passwordAgainTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        hideKeyboardWhenTappedAround()
        textFields.forEach {$0.delegate = self}

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    
    
    func setupLayouts() {
        securitySettingsView.layer.cornerRadius = 10
        securitySettingsView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        securitySettingsView.backgroundColor = UIColor.white
        
        photoBackgroundView.layer.cornerRadius = photoBackgroundView.frame.height / 2
        photoBackgroundView.backgroundColor = UIColor.white
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.height / 2
        
        previousPasswordTextField.layer.cornerRadius = previousPasswordTextField.frame.height / 2
        previousPasswordTextField.setLeftPaddingPoints(10)
        previousPasswordTextField.setRightPaddingPoints(10)
        
        newPasswordTextField.layer.cornerRadius = newPasswordTextField.frame.height / 2
        newPasswordTextField.setLeftPaddingPoints(10)
        newPasswordTextField.setRightPaddingPoints(10)
        
        passwordAgainTextField.layer.cornerRadius = passwordAgainTextField.frame.height / 2
        passwordAgainTextField.setLeftPaddingPoints(10)
        passwordAgainTextField.setRightPaddingPoints(10)
        
        profilePhotoImageView.sd_setImage(with: URL(string: BaseURL.USER_IMAGE_URL + "\(photo ?? "default.jpeg")"), completed: nil)
    }

    @IBAction func updatePasswordButtonPressed(_ sender: UIButton) {
        if previousPasswordTextField.text != "" && newPasswordTextField.text != "" && passwordAgainTextField.text != "" {
            updatePassword()

        } else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen gerekli alanları doldurunuz.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func backButttonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func updatePassword() {
        
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "change-password")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        
        //HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "old_password=\(previousPasswordTextField.text!)&new_password=\(newPasswordTextField.text!)"
        print("old_password=\(previousPasswordTextField.text!)&new_password=\(newPasswordTextField.text!)")
        
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        // Set HTTP Request Header
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // Set HTTP Request URL Encoded
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
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
                
                let loginResponse = try JSONDecoder().decode(PostMessageResponse.self, from: data)
                
                if loginResponse.status{
                    DispatchQueue.main.async {
                        

                        
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let alert = UIAlertController(title: "Hata", message: loginResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }catch let jsonError {
                print("Change Password Response = \(jsonError)")
            }
            
        }
        task.resume()
    }
    
}



extension EditProfileVC  : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let selectedTextFieldIndex = textFields.firstIndex(of: textField), selectedTextFieldIndex < textFields.count - 1 {
            textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder() // last textfield, dismiss keyboard directly
        }
        return true
    }
}
