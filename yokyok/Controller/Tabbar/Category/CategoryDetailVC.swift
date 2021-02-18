//
//  CategoryDetailVC.swift
//  yokyok
//
//  Created by Nazik on 11.02.2021.
//

import UIKit
import SDWebImage

class CategoryDetailVC: UIViewController {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoryDetailCollectionView: UICollectionView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    var isLoadingMoreItems = false
    var lastPage = 0
    var category_id : Int?
    var titleName = ""
    var productsArray = [ProductDataResponse?]()
    var categoriesArray = [CategoriesDataResponse?]()
    var pageIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        categoryDetailCollectionView.dataSource = self
        categoryDetailCollectionView.delegate = self
        //print("***\(category_id)")
        getProducts()
        getCategories()
        
        setupLayouts()
        print(lastPage)
    }
    
    func setupLayouts() {
        categoryTitleLabel.text = titleName
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- NETWORKING
    func getProducts() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "products?category_id=\(category_id!)&page=\(pageIndex)")
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
                            
                            
                            self.lastPage = productResponse.last_page!
                            
                            if self.productsArray.isEmpty {
                                self.productsArray = productResponse.data
                            } else {
                                self.productsArray.append(contentsOf: productResponse.data)

                            }
                            self.categoryDetailCollectionView.reloadData()

                            
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
    
    func getCategories() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "categories")
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
                
                let categoriesResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                
                if categoriesResponse.status{
                    DispatchQueue.main.async {
                        if categoriesResponse.data.isEmpty == false {
                            
                            self.categoriesArray = categoriesResponse.data
                            //print(self.categoriesArray)
                            self.categoriesCollectionView.reloadData()
                            
                        } else {
                            print("data yok")
                        }
                        //                        self.removeViewsForAnimation()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //                        self.removeViewsForAnimation()
                        let alert = UIAlertController(title: "Hata", message: categoriesResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }catch let jsonError{
                print("Categories Response = \(jsonError)")
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        guard !isLoadingMoreItems else { return }
        if categoryDetailCollectionView.contentOffset.y >= categoryDetailCollectionView.contentSize.height - categoryDetailCollectionView.bounds.size.height{
            
            isLoadingMoreItems = false
            pageIndex += 1
            getProducts()
        }
    }
    
    func updatePhotosAfterFetching(_ product: [ProductDataResponse]) {
        isLoadingMoreItems = false
        self.productsArray.append(contentsOf: product)
        categoryDetailCollectionView.reloadData()
    }
    
}

extension CategoryDetailVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categoriesArray.count
        } else {
            return productsArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryDetailCategoryCell
            cell.categoryNameLabel.text = categoriesArray[indexPath.item]?.title
            cell.configureCell()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryDetailCell
            cell.productPriceLabel.text = "\((productsArray[indexPath.item]?.prices.price)!) ₺" 
            cell.productDescriptionLabel.text =  productsArray[indexPath.item]?.title
            cell.productCategoryLabel.text = productsArray[indexPath.item]?.categories
            cell.productImageView.sd_setImage(with: URL(string: BaseURL.PRODUCT_IMAGE_URL + "\(productsArray[indexPath.row]?.photo ?? "default.jpeg")"), completed: nil)
            cell.configureCell()
            return cell
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView {
            return CGSize(width: 100, height: 40)
        } else {
            let size  = collectionView.frame.size
            return CGSize( width: (size.width - 30) / 2, height: 250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            let vc = self.storyboard?.instantiateViewController(identifier: "CategoryDetailVC") as! CategoryDetailVC
            vc.category_id = (categoriesArray[indexPath.item]?.id)!
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            let vc = self.storyboard?.instantiateViewController(identifier: "ProductDetailVC") as! ProductDetailVC
            vc.productID = (productsArray[indexPath.item]?.id)!
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
}
