//
//  PaymentScreenVC.swift
//  yokyok
//
//  Created by Nazik on 14.02.2021.
//

import UIKit

class PaymentScreenVC: UIViewController {
    
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var minimumAmountLabel: UILabel!
    @IBOutlet weak var payAtTheDoorButton: UIButton!
    
    var addressesArray = [AllAddressesDetailResponse]()
    var defaultAddressID = 0
    var payAtTheDoor = 0
    var contentOfCart = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("defaultAddressID\(defaultAddressID)")
        setupLayouts()
        getAddresses()
        
        addGestureRecognizer(view: addressView)
//
//        let notificationCenter: NotificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(self.getAddresses), name: .notificationA, object: nil)
    }
    
    func addGestureRecognizer(view: UIView) {
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gestureRecognizerMethods(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func gestureRecognizerMethods(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case addressView:
            let vc = self.storyboard?.instantiateViewController(identifier: "ChooseAddressBottomPopup") as! ChooseAddressBottomPopup
            vc.height = UIScreen.main.bounds.height / 2
            vc.dismissDuration = 1.0
            vc.presentDuration = 1.0
            vc.shouldDismissInteractivelty = true
            self.present(vc, animated: true, completion: nil)
            default:
            break
        }
    }
    
    func setupLayouts() {
        
        paymentView.layer.cornerRadius  = 10
        paymentView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        
        addressView.layer.cornerRadius = 10
        addressView.layer.backgroundColor = UIColor.white.cgColor
        addressView.layer.borderColor = UIColor.orange.cgColor
        addressView.layer.borderWidth = 1
        
        payButton.layer.cornerRadius = payButton.frame.height / 2
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payAtTheDoorButtonPressed(_ sender: UIButton) {
        if payAtTheDoorButton.isSelected {
            payAtTheDoorButton.isSelected = false
            payAtTheDoor = 0
        }
        else {
            payAtTheDoorButton.isSelected = true
            payAtTheDoor = 1
        }
    }
    
    @IBAction func makePaymentButtonPressed(_ sender: UIButton) {
        makeOrder()
        
    }
    
    
    //MARK:- NETWORK
    func getAddresses() {
    
    let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
    
    // Prepare URL
    let url = URL(string: BaseURL.baseURL + "address")
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
            
            let addressResponse = try JSONDecoder().decode(AllAddressesResponse.self, from: data)
            
            if addressResponse.status{
                DispatchQueue.main.async { [self] in
                    if addressResponse.data?.addresses?.isEmpty == false {
                        
                        self.addressesArray.removeAll()
                        
                        self.addressesArray = addressResponse.data!.addresses!
                        self.defaultAddressID = addressResponse.data!.default_id!
                        
                        
                        
                        for i in self.addressesArray {
                            if i.id! == self.defaultAddressID {
                                self.addressTitleLabel.text = i.title!
                                self.districtLabel.text = i.county_name!
                                self.addressLabel.text = i.address!
                                print("found")
                                print("id: \(i.id!) --> \(i.address!) \(i.county!) \(i.county_name!)")
                                break
                            }
                        }
                        
                        
                        print(defaultAddressID)
                        getMinimumPrice(id: defaultAddressID)
                        
                        
                    } else {
                        print("data yok")
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    let alert = UIAlertController(title: "Hata", message: addressResponse.message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        } catch let jsonError{
            print("Get address Response = \(jsonError)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                let alert = UIAlertController(title: "Hata", message: "Sunucu Hatası", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    task.resume()
}
    
    func getSpesificAddress(id: Int) {
    
    let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
    
    // Prepare URL
    let url = URL(string: BaseURL.baseURL + "address")
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
            
            let addressResponse = try JSONDecoder().decode(AllAddressesResponse.self, from: data)
            
            if addressResponse.status{
                DispatchQueue.main.async { [self] in
                    if addressResponse.data?.addresses?.isEmpty == false {
                        
                        self.addressesArray.removeAll()
                        self.addressesArray = addressResponse.data!.addresses!
                        
                        for i in self.addressesArray {
                            if i.id! == id {
                                self.addressTitleLabel.text = i.title!
                                self.districtLabel.text = i.county_name!
                                self.addressLabel.text = i.address!
                                print("found")
                                print("id: \(i.id!) --> \(i.address!) \(i.county!) \(i.county_name!)")
                                break
                            }
                        }
                        
                        
                        print(id)
                        getMinimumPrice(id: id)
                        
                        
                    } else {
                        print("data yok")
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    let alert = UIAlertController(title: "Hata", message: addressResponse.message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        } catch let jsonError{
            print("Get address Response = \(jsonError)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                let alert = UIAlertController(title: "Hata", message: "Sunucu Hatası", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    task.resume()
}
    

    //MARK:- NETWORKING
    func getMinimumPrice(id: Int) {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!

        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "get-minimum-price/\(id)")
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
//
                let minPriceResponse = try JSONDecoder().decode(MinPriceResponse.self, from: data)

                if minPriceResponse.status{
                    DispatchQueue.main.async {

                        self.minimumAmountLabel.text = minPriceResponse.data.min_price

//
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.removeViewsForAnimation()
                        let alert = UIAlertController(title: "Hata", message: minPriceResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)

                        self.present(alert, animated: true, completion: nil)
                    }
                }

            }catch let jsonError{
                print("Min Price Response = \(jsonError)")
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
    

    //MARK:- NETWORKING
    func makeOrder() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!

        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "order")
        
        guard let requestUrl = url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"

        let postString = "products=\(contentOfCart)&address_id=\(defaultAddressID)&payment_type=1"
        print("products=\(contentOfCart)&address_id=\(defaultAddressID)&payment_type=1")
        
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
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

                let minPriceResponse = try JSONDecoder().decode(PostMessageResponse.self, from: data)

                if minPriceResponse.status{
                    DispatchQueue.main.async {
                        
                        let vc = SuccessfulPaymentPopup(nibName: "SuccessfulPaymentPopup", bundle: nil)
                        vc.modalPresentationStyle = .overCurrentContext
                        self.present(vc, animated: false, completion: nil)

                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.removeViewsForAnimation()
                        let alert = UIAlertController(title: "Hata", message: minPriceResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)

                        self.present(alert, animated: true, completion: nil)
                    }
                }

            }catch let jsonError{
                print("Min Price Response = \(jsonError)")
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


extension Notification.Name {
    static let notificationA = Notification.Name("NotificationA")
}
