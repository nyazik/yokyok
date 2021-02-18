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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(addressTitleLabel)
        setupLayouts()
        
        addGestureRecognizer(view: addressView)
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
            vc.dismissDuration = 3.0
            vc.presentDuration = 3.0
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
            //defaultAddress = 0
        }
        else {
            payAtTheDoorButton.isSelected = true
            //defaultAddress = 1
        }
    }
    @IBAction func makePaymentButtonPressed(_ sender: UIButton) {
        let vc = SuccessfulPaymentPopup(nibName: "SuccessfulPaymentPopup", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
        
//        let vc = self.storyboard?.instantiateViewController(identifier: "ChooseAddressBottomPopup") as! ChooseAddressBottomPopup
//        vc.height = 300
//        vc.dismissDuration = 3.0
//        vc.presentDuration = 3.0
//        vc.shouldDismissInteractivelty = true
//        self.present(vc, animated: true, completion: nil)
    }
    
    
    
//
//    //MARK:- NETWORKING
//    func getMinimumPrice() {
//        //addViewsForAnimation()
//        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
//
//        // Prepare URL
//        let url = URL(string: BaseURL.baseURL + "get-minimum-price\()")
//        guard let requestUrl = url else { fatalError() }
//
//        // Prepare URL Request Object
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = "GET"
//
//        // Set HTTP Request Header
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//
//        // Perform HTTP Request
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            // Check for Error
//            if let error = error {
//                print("Error took place \(error)")
//                return
//            }
//
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                //print(dataString)
//            }
//
//            guard let data = data else {return}
//
//            do{
//
//                let categoriesResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
//
//                if categoriesResponse.status{
//                    DispatchQueue.main.async {
//                        if categoriesResponse.data.isEmpty == false {
//
//                            self.categoriesArray = categoriesResponse.data
//                            //print(self.categoriesArray)
//                            self.categoriesCollectionView.reloadData()
//
//                        } else {
//                            print("data yok")
//                        }
////                        self.removeViewsForAnimation()
//                    }
//                } else {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
////                        self.removeViewsForAnimation()
//                        let alert = UIAlertController(title: "Hata", message: categoriesResponse.message, preferredStyle: .alert)
//                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
//                        alert.addAction(ok)
//
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//
//            }catch let jsonError{
//                print("Categories Response = \(jsonError)")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    //self.removeViewsForAnimation()
//                    let alert = UIAlertController(title: "Hata", message: "Sunucu Hatası", preferredStyle: .alert)
//                    let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
//                    alert.addAction(ok)
//
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }
//        task.resume()
//    }
//
}
