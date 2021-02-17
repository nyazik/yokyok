//
//  ForgotPasswordVC.swift
//  yokyok
//
//  Created by Nazik on 10.02.2021.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupLayouts()
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
        
        sendButton.roundCorners(corners: [.allCorners], radius: emailTextField.frame.height / 2)
        
        sendButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        sendButton.layer.shadowOpacity = 1.0
        sendButton.layer.shadowRadius = 0.0
        sendButton.layer.masksToBounds = false
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if emailTextField.text != "" {
            if emailTextField.text!.isValidEmail() {
                forgotPasswordUser()
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
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- Networking
    func forgotPasswordUser() {
        
//        addViewsForAnimation()
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "reset-password")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        //HTTP Request Parameters which will be sent in HTTP Request Body
        let postString =
            "email=\(emailTextField.text!)"
        
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
                
                let registerResponse = try JSONDecoder().decode(PostMessageResponse.self, from: data)
                
                if registerResponse.status{
                    DispatchQueue.main.async {
                        
                        //self.removeViewsForAnimation()
                        
                        
                        let vc = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginVC
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                       
                    }
                } else {
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
