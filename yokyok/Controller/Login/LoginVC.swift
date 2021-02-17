//
//  LoginVC.swift
//  yokyok
//
//  Created by Nazik on 10.02.2021.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    var textFields: [UITextField] {
        return [emailTextField, passwordTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupLayouts()
        textFields.forEach {$0.delegate = self}
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    func setupLayouts() {
        emailTextField.roundCorners(corners: [.allCorners], radius: emailTextField.frame.height / 2)
        emailTextField.setLeftPaddingPoints(15)
        emailTextField.setRightPaddingPoints(15)
        
        passwordTextField.roundCorners(corners: [.allCorners], radius: passwordTextField.frame.height / 2)
        passwordTextField.setLeftPaddingPoints(15)
        passwordTextField.setRightPaddingPoints(15)

        signInButton.roundCorners(corners: [.allCorners], radius: signInButton.frame.height / 2)
        signInButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        signInButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        signInButton.layer.shadowOpacity = 1.0
        signInButton.layer.shadowRadius = 0.0
        signInButton.layer.masksToBounds = false
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            if emailTextField.text!.isValidEmail() {
                loginUser()
            } else {
                let alert = UIAlertController(title: "Hata", message: "Lütfen geçerli bir e-posta adresi giriniz.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen gerekli alanları doldurunuz.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ForgotPasswordVC") as! ForgotPasswordVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        
        let vc = self.storyboard?.instantiateViewController(identifier: "RegisterVC") as! RegisterVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //MARK: -Networking
    func loginUser() {

        //addViewsForAnimation()
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "login")
        
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        //HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "email=\(emailTextField.text!)&password=\(passwordTextField.text!)"
        
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
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
                
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                if loginResponse.status{
                    DispatchQueue.main.async {
                        
                        print("ACCESS TOKEN: \(loginResponse.data!.token!)")
                        
                        UserDefaults.standard.set(loginResponse.data!.token!, forKey: "Autherization")
                        
                        let vc = self.storyboard?.instantiateViewController(identifier: "MainPageVC") as! MainPageVC
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        //self.removeViewsForAnimation()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //self.removeViewsForAnimation()
                        let alert = UIAlertController(title: "Hata", message: loginResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            } catch let jsonError{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("Login Response = \(jsonError)")
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


extension LoginVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let selectedTextFieldIndex = textFields.firstIndex(of: textField), selectedTextFieldIndex < textFields.count - 1 {
            textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder() // last textfield, dismiss keyboard directly
        }
        return true
    }
}


