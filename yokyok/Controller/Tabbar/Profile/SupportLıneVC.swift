//
//  SupportLıneVC.swift
//  yokyok
//
//  Created by Nazik on 12.02.2021.
//

import UIKit

class SupportLineVC: UIViewController {
    
    @IBOutlet weak var supportThemeTextField: UITextField!
    @IBOutlet weak var supportDescriptionTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        supportDescriptionTextView.delegate = self

    }
    
    func setupLayouts() {
        hideKeyboardWhenTappedAround()
        supportThemeTextField.setRightPaddingPoints(10)
        supportThemeTextField.setLeftPaddingPoints(10)
        supportThemeTextField.layer.cornerRadius = supportThemeTextField.frame.height / 2
//        supportThemeTextField.layer.borderWidth = 1
//        supportThemeTextField.layer.borderColor = UIColor.lightGray.cgColor
            
        supportDescriptionTextView.layer.cornerRadius = 10
//        supportDescriptionTextView.layer.borderWidth = 1
//        supportDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        supportDescriptionTextView.padding()
        supportDescriptionTextView.text = "Adres Bilgilerinizi Giriniz"
        supportDescriptionTextView.textColor = UIColor.lightGray
        
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if supportThemeTextField.text != "" && supportDescriptionTextView.text != "" &&  supportDescriptionTextView.text != "Adres Bilgilerinizi Giriniz"{
                postSupport()
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
    
    func postSupport() {
        
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string:BaseURL.baseURL + "support")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        //HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "title=\(supportThemeTextField.text!)&description=\(supportDescriptionTextView.text!)"
        
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
                        
                        print("success")
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        let alert = UIAlertController(title: "Hata", message: registerResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }catch let jsonError{
                print("Support Response = \(jsonError)")
            }
            
        }
        task.resume()
    }
    
}


extension SupportLineVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Adres Bilgilerinizi Giriniz"
            textView.textColor = UIColor.lightGray
        }
    }
}

