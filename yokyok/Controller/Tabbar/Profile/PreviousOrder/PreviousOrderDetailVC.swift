//
//  PreviousOrderDetailVC.swift
//  yokyok
//
//  Created by Nazik on 13.02.2021.
//

import UIKit
import SDWebImage

class PreviousOrderDetailVC: UIViewController {
    
    
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderAddressTitleLabel: UILabel!
    @IBOutlet weak var orderAddressLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var courierPriceLabel: UILabel!
    @IBOutlet var previousOrdersDetailTableView: UITableView!
    @IBOutlet weak var previousOrdersDetailTableViewHeightConstraint: NSLayoutConstraint!
    
    var previousOrderDetailArray = [PreviousOrderDataResponse]()
    
    var previousOrderId = 0
    var orderDate = ""
    var orderAddressTitle = ""
    var orderAddress = ""
    var totalPrice = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        previousOrdersDetailTableView.dataSource = self
        previousOrdersDetailTableView.delegate = self
        
        getHistoricalOrderDetail()
        
        setupLayouts()
    }
    
    
    override func viewDidLayoutSubviews() {
        previousOrdersDetailTableViewHeightConstraint.constant = CGFloat.greatestFiniteMagnitude
        self.previousOrdersDetailTableView.reloadData()
        self.loadViewIfNeeded()
        previousOrdersDetailTableViewHeightConstraint.constant = self.previousOrdersDetailTableView.contentSize.height
    }
 
    func setupLayouts() {
        orderDateLabel.text = orderDate
        orderAddressTitleLabel.text = orderAddressTitle
        orderAddressLabel.text = orderAddress
        totalPriceLabel.text = totalPrice
        orderPriceLabel.text = totalPrice
        courierPriceLabel.text = "Ücretsiz"
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    
    //MARK:- NETWORKING
    func getHistoricalOrderDetail() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "orders/\(previousOrderId)")
        
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
                
                let productResponse = try JSONDecoder().decode(PreviousOrderDetailResponse.self, from: data)

                if productResponse.status{
                    DispatchQueue.main.async { [self] in
                        if productResponse.data!.isEmpty == false {
                            previousOrderDetailArray = productResponse.data!
                            print("previousOrderDetail\(previousOrderDetailArray)")
//                            self.productsArray = productResponse.data
//                            print(self.productsArray)
                            self.previousOrdersDetailTableView.reloadData()
                            
                            self.previousOrdersDetailTableViewHeightConstraint.constant = CGFloat.greatestFiniteMagnitude
                            self.previousOrdersDetailTableView.reloadData()
                            self.previousOrdersDetailTableView.layoutIfNeeded()
                            self.previousOrdersDetailTableViewHeightConstraint.constant = self.previousOrdersDetailTableView.contentSize.height
                        } else {
                            print("data yok")
                        }
//                        self.removeViewsForAnimation()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.removeViewsForAnimation()
                        let alert = UIAlertController(title: "Hata", message: productResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)

                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }catch let jsonError{
                print("Product Response = \(jsonError)")
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

extension PreviousOrderDetailVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousOrderDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PreviousOrderDetailCell
        cell.productImageView.sd_setImage(with: URL(string: BaseURL.PRODUCT_IMAGE_URL + "\(previousOrderDetailArray[indexPath.row].original.photo ?? "default.jpeg")"), completed: nil)
        cell.productTitleLabel.text = previousOrderDetailArray[indexPath.row].original.title
        cell.productCategoryLabel.text = previousOrderDetailArray[indexPath.row].original.categories
        cell.productPriceLabel.text = previousOrderDetailArray[indexPath.row].price
        cell.productQuantityLabel.text = String(previousOrderDetailArray[indexPath.row].count!)
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
