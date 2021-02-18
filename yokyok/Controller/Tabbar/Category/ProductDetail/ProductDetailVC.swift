//
//  ProductDetailVC.swift
//  yokyok
//
//  Created by Nazik on 11.02.2021.
//

import UIKit
import SDWebImage
import CoreData
import GMStepper

class ProductDetailVC: UIViewController {
    
    @IBOutlet weak var productQuantityStepper: GMStepper!
    @IBOutlet weak var productDetailView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productDescriptionView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productTiteLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var productID = 0
    var itemArray = [Cart]()
    var currentStepperValue = 1
    var contentOfCart = ""
    var modelConvertToJson: [modelConverToJsonResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
        
        print(productID)
        getProductDetail()
        //        print("itemArray\(itemArray)")
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print("productQuantityStepper\(productQuantityStepper.value)")
    }
    
    func setupLayouts() {
        
        productDetailView.layer.borderColor = UIColor.lightGray.cgColor
        productDetailView.layer.borderWidth = 0.3
        
        productDescriptionView.layer.borderColor = UIColor.lightGray.cgColor
        productDescriptionView.layer.borderWidth = 0.3
        
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height / 2
        
        productQuantityStepper.value = 1
    }
    
    @IBAction func currentValueOfStepper(_ sender: UIControl) {
        currentStepperValue = Int(productQuantityStepper.value)
        print(currentStepperValue)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToFavouriteButtonPressed(_ sender: UIButton) {
        addToFavourite()
    }
    
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        if productQuantityStepper.value >= 0 {
            let addToCart = Cart(context: context)
            addToCart.product_id = Int32(productID)
            addToCart.product_quantity = Int32(currentStepperValue)
            
            dismiss(animated: true, completion: nil)
            saveItems()
            loadItems()
        } else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen gerekli alanları seçiniz.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("error saving context\(error)")
        }
    }
    
    
    
    //MARK:- NETWORKING
    func getProductDetail() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "product/\(productID)")
        print(BaseURL.baseURL + "product/\(productID)")
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
                //print(dataString)
            }
            
            guard let data = data else {return}
            
            do{
                
                let productDetailResponse = try JSONDecoder().decode(ProductDetailResponse.self, from: data)
                
                if productDetailResponse.status{
                    DispatchQueue.main.async { [self] in
                        productImageView.sd_setImage(with: URL(string: BaseURL.PRODUCT_IMAGE_URL + "\(productDetailResponse.data.photo ?? "default.jpeg")"), completed: nil)
                        productPriceLabel.text =  "\(productDetailResponse.data.prices.price) ₺"
                        productTiteLabel.text = productDetailResponse.data.title
                        productCategoryLabel.text = productDetailResponse.data.categories
                        productDescriptionLabel.text = productDetailResponse.data.description
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //                        self.removeViewsForAnimation()
                        let alert = UIAlertController(title: "Hata", message: productDetailResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }catch let jsonError{
                print("getProductDetail Response = \(jsonError)")
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
    
    func addToFavourite() {
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string:BaseURL.baseURL + "favorite/\(productID)")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        //HTTP Request Parameters which will be sent in HTTP Request Body
        //        let postString = "title=\(addressTitleTextField.text!)&address=\(addressTextView.text!)&is_default=\(0)"
        ////        print("title=\(addressTitleTextField.text!)&address=\(addressTextView.text!)&is_default=\(1)")
        //        // Set HTTP Request Body
        //        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                //print(dataString)
            }
            
            guard let data = data else {return}
            
            do{
                
                let registerResponse = try JSONDecoder().decode(PostMessageResponse.self, from: data)
                
                if registerResponse.status{
                    DispatchQueue.main.async {
                        print("added to favourite")
                        
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
                print("addToFavourite Response = \(jsonError)")
            }
            
        }
        task.resume()
    }
    
    func loadItems() {
        let request : NSFetchRequest<Cart> = Cart.fetchRequest()
        do{
            itemArray = try context.fetch(request)
            
            for i in itemArray {
                self.modelConvertToJson.append(modelConverToJsonResponse(id: Int(i.product_id), count: Int(i.product_quantity)))
            }
            
            print(self.modelConvertToJson)
            
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(self.modelConvertToJson) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    contentOfCart = jsonString
                }
            }
            
        }catch{
            print("error fetching data from DB\(error)")
        }
        calculateCart()
    }
    
    func calculateCart() {
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string:BaseURL.baseURL + "basket")
        print(BaseURL.baseURL + "basket")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        //HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "products=\(contentOfCart)"
        print("***\(contentOfCart)")
        //print("****\(contentOfCart)")
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
                
//                let registerResponse = try JSONDecoder().decode(PostMessageResponse.self, from: data)
//
//                if registerResponse.status{
//                    DispatchQueue.main.async {
//
//                        //NotificationCenter.default.post(name: .buyPackage, object: nil)
//
//                        let vc = self.storyboard?.instantiateViewController(identifier: "MyAddressedVC") as! MyAddressedVC
//                        vc.modalPresentationStyle = .fullScreen
//                        self.present(vc, animated: false, completion: nil)
//                        //self.dismiss(animated: true, completion: nil)
//
//                    }
//                } else {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//
//                        let alert = UIAlertController(title: "Hata", message: registerResponse.message, preferredStyle: .alert)
//                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
//                        alert.addAction(ok)
//
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
                
            }catch let jsonError{
                print("Card details Response = \(jsonError)")
            }
            
        }
        task.resume()
    }
    
    
}
