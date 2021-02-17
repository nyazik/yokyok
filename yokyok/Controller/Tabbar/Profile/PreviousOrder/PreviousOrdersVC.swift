//
//  PrevıousOrdersVC.swift
//  yokyok
//
//  Created by Nazik on 13.02.2021.
//

import UIKit

class PreviousOrdersVC: UIViewController {
    
    @IBOutlet weak var previousOrderTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousOrderTableView.dataSource = self
        previousOrderTableView.delegate = self
        
        getHistoricalOrders()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- NETWORKING
    func getHistoricalOrders() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "orders")
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
                
                let productResponse = try JSONDecoder().decode(GetHistoricalOrders.self, from: data)

                if productResponse.status{
                    DispatchQueue.main.async {
                        if productResponse.data.isEmpty == false {
                            
                            
//                            self.productsArray = productResponse.data
//                            print(self.productsArray)
//                            self.popularProductsCollectionView.reloadData()

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

extension PreviousOrdersVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PreviousOrderCell
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "PreviousOrderDetailVC") as! PreviousOrderDetailVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
   
    
}
