//
//  MainPageVC.swift
//  yokyok
//
//  Created by Nazik on 10.02.2021.
//

import UIKit
import SDWebImage

class MainPageVC: UIViewController {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var popularProductsCollectionView: UICollectionView!
    @IBOutlet weak var popularCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var pageIndicatorPageControl: UIPageControl!
    @IBOutlet weak var tabbarView: UIView!
    
    @IBOutlet weak var tabbarMainPageView: UIView!
    @IBOutlet weak var tabbarCategoriesView: UIView!
    @IBOutlet weak var tabbarMyFavouriteView: UIView!
    @IBOutlet weak var tabbarMyProfileView: UIView!
    
    var categoriesArray = [CategoriesDataResponse?]()
    var productsArray = [ProductDataResponse?]()
    var slidersArray = [SliderDataResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        
        popularProductsCollectionView.dataSource = self
        popularProductsCollectionView.delegate = self
        
        popularCategoriesCollectionView.dataSource = self
        popularCategoriesCollectionView.delegate = self
        
        setupLayouts()
        
        //MARK:- GESTURE RECOGNIZER
        addGestureRecognizer(view: tabbarCategoriesView)
        addGestureRecognizer(view: tabbarMyFavouriteView)
        addGestureRecognizer(view: tabbarMyProfileView)
        
        getCategories()
        getProducts()
        getSlider()
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
        default:
            break
        }
    }
    
    func setupLayouts() {
        pageIndicatorPageControl.numberOfPages = slidersArray.count
        
        tabbarView.backgroundColor = UIColor.white
        tabbarView.layer.borderWidth = 1
        tabbarView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func allCategoriesButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CategoriesVC") as! CategoriesVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func myCartTabbarButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "MyCartVC") as! MyCartVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    //MARK:- NETWORKING
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
                            self.popularCategoriesCollectionView.reloadData()
                            
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
    
    //MARK:- NETWORKING
    func getProducts() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "products")
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
                
                let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)

                if productResponse.status{
                    DispatchQueue.main.async {
                        if productResponse.data.isEmpty == false {

                            self.productsArray = productResponse.data
                            //print(self.productsArray)
                            self.popularProductsCollectionView.reloadData()

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
    
    //MARK:- NETWORKING
    func getSlider() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "sliders")
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
                
                let productResponse = try JSONDecoder().decode(SliderResponse.self, from: data)

                if productResponse.status{
                    DispatchQueue.main.async {
                        if productResponse.data.isEmpty == false {
                            print("****")
                            self.slidersArray = productResponse.data
                            //print(self.productsArray)
                            self.bannerCollectionView.reloadData()

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


extension MainPageVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularProductsCollectionView {
            return productsArray.count
        } else if collectionView == popularCategoriesCollectionView {
            return categoriesArray.count
        } else {
            return slidersArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularProductsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCell", for: indexPath) as! PopularProductCell
            cell.productPriceLabel.text =  productsArray[indexPath.row]?.prices.price
            cell.productDescriptionLabel.text = productsArray[indexPath.row]?.title
            cell.productCategoryLabel.text = productsArray[indexPath.row]?.categories
            cell.productImageView.sd_setImage(with: URL(string: BaseURL.PRODUCT_IMAGE_URL + "\(productsArray[indexPath.row]?.photo ?? "default.jpeg")"), completed: nil)
            cell.configureCell()
            return cell
        } else if collectionView == popularCategoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! PopularCategoryCell
            cell.popularCategoryProductNameLabel.text = categoriesArray[indexPath.row]?.title
            cell.popularCategoryProductQuantityLabel.text = "\(String((categoriesArray[indexPath.row]?.count)!)) Ürün"
            cell.popularCategoryImageView.sd_setImage(with: URL(string: BaseURL.CATEGORY_IMAGE_URL + "\(categoriesArray[indexPath.row]?.photo ?? "default.jpeg")"), completed: nil)
            cell.configureCell()
            return  cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BannerCell
            cell.bannerImageView.sd_setImage(with: URL(string: BaseURL.slider + "\(slidersArray[indexPath.item].image! ?? "default.jpeg")"), completed: nil)
            print(BaseURL.slider + slidersArray[indexPath.item].image!)
            //print(slidersArray[indexPath.item].image )
            cell.configureCell()
            return  cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == popularProductsCollectionView {
            let size  = collectionView.frame.size
            return CGSize(width: size.width / 2, height: 250)
        } else if collectionView == popularCategoriesCollectionView {
            let size  = collectionView.frame.size
            return CGSize(width: 100 , height: 160)
            
        }else {
            let size  = collectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == popularProductsCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else if collectionView == popularCategoriesCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = bannerCollectionView.indexPathForItem(at: center) {
            self.pageIndicatorPageControl.currentPage = ip.row
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            
        } else if collectionView == popularProductsCollectionView {
            let vc = self.storyboard?.instantiateViewController(identifier: "ProductDetailVC") as! ProductDetailVC
            vc.productID = (productsArray[indexPath.item]?.id)!
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else {
            let vc = self.storyboard?.instantiateViewController(identifier: "CategoryDetailVC") as! CategoryDetailVC
            vc.category_id  = (categoriesArray[indexPath.item]?.id)!
            vc.titleName = (categoriesArray[indexPath.item]?.title)!
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
