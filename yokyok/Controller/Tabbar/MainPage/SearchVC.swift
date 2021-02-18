//
//  SearchVC.swift
//  yokyok
//
//  Created by Nazik on 18.02.2021.
//

import UIKit

class SearchVC: UIViewController {

    var searchQuery = "" 
    @IBOutlet weak var searchCollectionView: UICollectionView!
    var productsArray = [ProductDataResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        getProducts()
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- NETWORKING
    func getProducts() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "search?query=\(searchQuery)")
        guard let requestUrl = url else { fatalError() }
        // print("products?category_id=\(category_id!)&page=\(pageIndex)")
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
                
                let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                
                if productResponse.status{
                    DispatchQueue.main.async { [self] in
                        if productResponse.data.isEmpty == false {
                            
                            if self.productsArray.isEmpty {
                                self.productsArray = productResponse.data
                            } else {
                                self.productsArray.append(contentsOf: productResponse.data)
                            }
                            self.searchCollectionView.reloadData()
                            print("productsArray\(productsArray)")
                            
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

extension SearchVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCell
        
        cell.productPriceLabel.text = "\((productsArray[indexPath.item].prices.price)) ₺"
        cell.productDescriptionLabel.text =  productsArray[indexPath.item].title
        cell.productCategoryLabel.text = productsArray[indexPath.item].categories
        cell.productImageView.sd_setImage(with: URL(string: BaseURL.PRODUCT_IMAGE_URL + "\(productsArray[indexPath.row].photo ?? "default.jpeg")"), completed: nil)
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size  = collectionView.frame.size
        return CGSize( width: (size.width - 30) / 2, height: 250)
    }
    
}
