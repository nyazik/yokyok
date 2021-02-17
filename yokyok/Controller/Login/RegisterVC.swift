//
//  RegisterVC.swift
//  yokyok
//
//  Created by Nazik on 10.02.2021.
//

import UIKit
import Lottie
class RegisterVC: UIViewController {
    
    @IBOutlet weak var nameSurnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var textFields: [UITextField] {
        return [nameSurnameTextField, emailTextField, phoneTextField, passwordTextField, passwordAgainTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        textFields.forEach {$0.delegate = self}
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    
    func setupLayouts() {
        nameSurnameTextField.roundCorners(corners: [.allCorners], radius: emailTextField.frame.height / 2)
        nameSurnameTextField.setLeftPaddingPoints(15)
        nameSurnameTextField.setRightPaddingPoints(15)
        
        emailTextField.roundCorners(corners: [.allCorners], radius: emailTextField.frame.height / 2)
        emailTextField.setLeftPaddingPoints(15)
        emailTextField.setRightPaddingPoints(15)
        
        phoneTextField.roundCorners(corners: [.allCorners], radius: emailTextField.frame.height / 2)
        phoneTextField.setLeftPaddingPoints(15)
        phoneTextField.setRightPaddingPoints(15)
        
        passwordTextField.roundCorners(corners: [.allCorners], radius: emailTextField.frame.height / 2)
        passwordTextField.setLeftPaddingPoints(15)
        passwordTextField.setRightPaddingPoints(15)
        
        passwordAgainTextField.roundCorners(corners: [.allCorners], radius: emailTextField.frame.height / 2)
        passwordAgainTextField.setLeftPaddingPoints(15)
        passwordAgainTextField.setRightPaddingPoints(15)
        
        registerButton.roundCorners(corners: [.allCorners], radius: registerButton.frame.height / 2)
        registerButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        registerButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        registerButton.layer.shadowOpacity = 1.0
        registerButton.layer.shadowRadius = 0.0
        registerButton.layer.masksToBounds = false
    }

    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if nameSurnameTextField.text != "" && emailTextField.text != "" && phoneTextField.text != "" && passwordTextField.text != "" && passwordAgainTextField.text != "" {
            if emailTextField.text!.isValidEmail(){
                if passwordTextField.text! == passwordAgainTextField.text! {
                    self.registerUser()
                }else{
                    let alert = UIAlertController(title: "Hata", message: "Şifreler uyuşmamaktadır. Lütfen kontrol ediniz.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }else {
                let alert = UIAlertController(title: "Hata", message: "Lütfen geçerli bir e-posta adresi giriniz.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            
        }else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen gerekli alanları doldurunuz.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    

    
    //MARK:- Networking
    func registerUser() {
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "register")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        //HTTP Request Parameters which will be sent in HTTP Request Body
        let postString =
            "name=\(nameSurnameTextField.text!)&email=\(emailTextField.text!)&phone=\(phoneTextField.text!)&password=\(passwordTextField.text!)"
        
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
                print("***\(dataString)")
            }
            
            guard let data = data else {return}
            
            do{
                //print(data)
                let registerResponse = try JSONDecoder().decode(PostMessageResponse.self, from: data)
                
                if registerResponse.status{
                    DispatchQueue.main.async {

                        let vc = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginVC
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)

                    }
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                        //self.removeViewsForAnimation()

                        let alert = UIAlertController(title: "Hata", message: registerResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)

                        self.present(alert, animated: true, completion: nil)
                    }
                }

            } catch let jsonError {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                    //self.removeViewsForAnimation()

                    print(jsonError)
                    let alert = UIAlertController(title: "Hata", message: "Sunucu Hatasi", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(ok)

                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    
    
}


extension RegisterVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let selectedTextFieldIndex = textFields.firstIndex(of: textField), selectedTextFieldIndex < textFields.count - 1 {
            textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder() // last textfield, dismiss keyboard directly
        }
        return true
    }
}


