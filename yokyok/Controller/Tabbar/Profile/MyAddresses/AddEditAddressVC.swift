//
//  AddEditAddressVC.swift
//  yokyok
//
//  Created by Nazik on 12.02.2021.
//

import UIKit
import iOSDropDown

class AddEditAddressVC: UIViewController {
    
    @IBOutlet weak var addressTitleTextField: UITextField!
    @IBOutlet weak var cityDropDown: DropDown!
    @IBOutlet weak var districtDropDown: DropDown!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var addEditAddressButton: UIButton!
    @IBOutlet weak var defaultAddressButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    var defaultAddress = 0
    var addressID = 0
    var districtId = 0
    var districtArray = [CityDataResponse]()
    var districtDropdownListArray: [String] = []
    var addressTitle = ""
    var address = ""
    var isNewAddress: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        hideKeyboardWhenTappedAround()
        addressTextView.delegate = self
        getCities()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    

    func setupLayouts() {
        
        hideKeyboardWhenTappedAround()
        
        configureTextFields(textFields: addressTitleTextField)
        configureTextFields(textFields: cityDropDown)
        configureTextFields(textFields: districtDropDown)
        
        addressTextView.layer.cornerRadius = 10
        
        addressTextView.text = "Adres Bilgilerinizi Giriniz"
        addressTextView.textColor = UIColor.lightGray
        addressTextView.padding()
        
        addEditAddressButton.layer.cornerRadius = addEditAddressButton.frame.height / 2
        cityDropDown.optionArray = ["İstanbul"]
        
        if isNewAddress == false {
            addEditAddressButton.titleLabel?.text = "Edit Address"
            addressTitleTextField.text = addressTitle
            cityDropDown.text = "İstanbul"
            //districtDropDown.text = disctric
            addressTextView.text = address
            
            self.districtDropDown.didSelect { (text, index, _) in
                print("District -> Text = \(text) - Index = \(index) - Id = \(self.districtArray[index].id!)")
                self.districtId = self.districtArray[index].id!
                print("districtId\(self.districtId)")
            }
            
//            let selectedCityIndex = districtArray.firstIndex{ $0.county_name == cityName }
//            districtDropDown.selectedIndex = selectedCityIndex
            print("city index = \(districtDropDown.selectedIndex)")
            //self.districtId = self.districtArray[districtDropDown.selectedIndex!].id!
            
            
//            let selectedDistrictIndex = districtArray.firstIndex{ $0.county_name == districtId }
//            districtDropDown.selectedIndex = selectedDistrictIndex
            print("disctric index = \(districtDropDown.selectedIndex)")
            //self.districtId = self.districtArray[districtDropDown.selectedIndex].id!
        }
        
        //print(BannerCell)
        print(addressTitle)
        print(address)
        print(districtId)
    }
    
    
    
    func configureTextFields(textFields: UITextField) {
        textFields.setLeftPaddingPoints(10)
        textFields.layer.cornerRadius = textFields.frame.height / 2
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func defaultAddressButtonPressed(_ sender: UIButton) {
        
        if defaultAddressButton.isSelected {
            defaultAddressButton.isSelected = false
            defaultAddress = 0
        }
        else {
            defaultAddressButton.isSelected = true
            defaultAddress = 1
        }
    }
    @IBAction func addEditButtonPressed(_ sender: UIButton) {
        addAddress()
        print("\(districtId)***")
    }
    
    
    //MARK:- NETWORKING
 
    func addAddress() {
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string:BaseURL.baseURL + "address")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        //HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "title=\(addressTitleTextField.text!)&address=\(addressTextView.text!)&is_default=\(defaultAddress)&city_id=34&county_id=\(districtId)"
        //print("title=\(addressTitleTextField.text!)&address=\(addressTextView.text!)&is_default=\(1)")
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
                        
                        //NotificationCenter.default.post(name: .buyPackage, object: nil)

                        let vc = self.storyboard?.instantiateViewController(identifier: "MyAddressedVC") as! MyAddressedVC
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: false, completion: nil)
                        //self.dismiss(animated: true, completion: nil)
                        
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
                print("Card details Response = \(jsonError)")
            }
            
        }
        task.resume()
    }
    
    //MARK: - Networking
    func getCities() {

        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "counties/34")
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
            
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print(dataString)
//            }
            
            guard let data = data else {return}
            
            do{
                
                let citiesResponse = try JSONDecoder().decode(CityResponse.self, from: data)
                
                if citiesResponse.status{
                    DispatchQueue.main.async { [self] in
                        if citiesResponse.data?.isEmpty == false {
                            self.districtArray = citiesResponse.data!
                            
                            for item in self.districtArray {
                                self.districtDropdownListArray.append(item.name!)
                                //print("**\(self.districtDropdownListArray)")
                            }
                            self.districtDropDown.optionArray = self.districtDropdownListArray
                            
                            self.districtDropDown.didSelect { (text, index, _) in
                                print("District -> Text = \(text) - Index = \(index) - Id = \(self.districtArray[index].id!)")
                                self.districtId = self.districtArray[index].id!
                                print("districtId\(districtId)")
                                
                            }
                            //self.configureDropDown()
                            
                        } else {
                            print("data yok")
                        }
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        let alert = UIAlertController(title: "Hata", message: citiesResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }catch let jsonError{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    print("Cities Response = \(jsonError)")
                    let alert = UIAlertController(title: "Hata", message: "Sunucu Hatası", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    
    
    func changeAddress() {
        
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "address/\(addressID)")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        
        self.districtDropDown.didSelect { [self] (text, index, _) in
            print("District -> Text = \(text) - Index = \(index) - Id = \(self.districtArray[index].id!)")
            self.districtId = self.districtArray[index].id!
        
        //HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "title=\(addressTitleTextField.text!)&address=\(addressTextView)&is_default=\(defaultAddress)&city_id=34&county_id=\(districtId)"
        
        //print("title=\(addressTitleTextField.text!)&province_id=\(cityId)&district_id=\(districtId)&details=\(addressTextField.text!)")
        
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
                        NotificationCenter.default.post(name: .editAddress, object: nil)

                        
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


}

extension AddEditAddressVC : UITextViewDelegate {
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

