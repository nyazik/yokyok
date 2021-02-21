//
//  MyCartVC.swift
//  yokyok
//
//  Created by Nazik on 12.02.2021.
//

import UIKit
import CoreData

class MyCartVC: UIViewController {
    
    @IBOutlet weak var mayCartTableView: UITableView!
    @IBOutlet weak var tabbarView: UIView!
    @IBOutlet weak var invoiceView: UIView!
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var total_basket_priceLabel: UILabel!
    @IBOutlet weak var total_products_priceLabel: UILabel!
    @IBOutlet weak var minimumAmountLabel: UILabel!
    @IBOutlet weak var courierPriceLabel: UILabel!
    
    @IBOutlet weak var tabbarMainPageView: UIView!
    @IBOutlet weak var tabbarCategoriesView: UIView!
    @IBOutlet weak var tabbarMyFavouriteView: UIView!
    @IBOutlet weak var tabbarMyProfileView: UIView!
    
    var totalOrderPrice = 0
    var minimumAmount = 0
    var cartQuantity = 0
    var contentOfCart = ""
    var cartArray = [CartProductsDetailResponse]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Cart]()
    var modelConvertToJson: [modelConverToJsonResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mayCartTableView.dataSource = self
        mayCartTableView.delegate = self
        
        setupLayouts()
        
        //MARK:- GESTURE RECOGNIZER
        addGestureRecognizer(view: tabbarCategoriesView)
        addGestureRecognizer(view: tabbarMyFavouriteView)
        addGestureRecognizer(view: tabbarMyProfileView)
        addGestureRecognizer(view: tabbarMainPageView)
        
        loadItems()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        

    }
    
    func addGestureRecognizer(view: UIView) {
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gestureRecognizerMethods(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func gestureRecognizerMethods(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case tabbarCategoriesView:
            let vc = self.storyboard?.instantiateViewController(identifier: "CategoriesVC") as! CategoriesVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        case tabbarMyFavouriteView:
            let vc = self.storyboard?.instantiateViewController(identifier: "FavouriteProductsVC") as! FavouriteProductsVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        case tabbarMyProfileView:
            let vc = self.storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        case tabbarMainPageView:
            let vc = self.storyboard?.instantiateViewController(identifier: "MainPageVC") as! MainPageVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        default:
            break
        }
    }
    
    func setupLayouts() {
        
        invoiceView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        invoiceView.layer.cornerRadius = 10
        
        tabbarView.backgroundColor = UIColor.white
        tabbarView.layer.borderWidth = 1
        tabbarView.layer.borderColor = UIColor.lightGray.cgColor
        
        payButton.layer.cornerRadius = payButton.frame.height / 2
        
    }
    
    
    @IBAction func payButtonPressed(_ sender: UIButton) {
        if totalOrderPrice != 0 {
            let vc = self.storyboard?.instantiateViewController(identifier: "PaymentScreenVC") as! PaymentScreenVC
            vc.contentOfCart = contentOfCart
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        } else {
            let alert = UIAlertController(title: "Hata", message: "Sepete Boş. ", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func loadItems() {
        
        let request : NSFetchRequest<Cart> = Cart.fetchRequest()
        do{
            let count = try context.count(for: request)
            print("count\(count)")
            cartQuantity = count
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
        if itemArray.count != 0 {
            calculateCart()
            
        }
        
    }
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("error saving context\(error)")
        }
    }
    
    @objc func calculateCart() {
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
                print("dataString\(dataString)")
            }
            
            guard let data = data else {return}
            
            do{
                
                
                let calculateCartResponse = try JSONDecoder().decode(CartResponse.self, from: data)
                
                if calculateCartResponse.status{
                    DispatchQueue.main.async { [self] in
                        self.total_basket_priceLabel.text = "\((calculateCartResponse.data?.total_basket_price!)!) ₺"
                        totalOrderPrice = Int((calculateCartResponse.data?.total_basket_price)!) ?? 0
                        print("totalOrderPrice\(totalOrderPrice)")
                        self.total_products_priceLabel.text = "\((calculateCartResponse.data?.total_products_price!)!) ₺"
                        self.courierPriceLabel.text = "\((calculateCartResponse.data?.courier_price!)!) ₺"
                        self.minimumAmountLabel.text = "\((calculateCartResponse.data?.address.min_price!)!) ₺"
                        self.cartArray = (calculateCartResponse.data?.products)!
                        self.mayCartTableView.reloadData()
                        //viewDidLoad()
                        print("calculate")
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        let alert = UIAlertController(title: "Hata", message: calculateCartResponse.message, preferredStyle: .alert)
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
    
}

extension MyCartVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCartCell
        cell.productDescriptionLabel.text = cartArray[indexPath.row].title
        cell.productCategoryLabel.text = cartArray[indexPath.row].categories
        cell.productPriceLabel.text = "\(cartArray[indexPath.row].total!) ₺"
        cell.productQuantityLabel.text = "\(String(cartArray[indexPath.row].count!)) adet"
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("deleted")
            context.delete(itemArray[indexPath.row])
            saveItems()
            cartArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
//          NotificationCenter.default.post(name: .updatePrice, object: nil)
            print("cartArray\(cartArray)")
            //calculateCart()
        }
        //viewDidLoad()
        //loadItems()
    }
    
    
}

