//
//  CategoriesVC.swift
//  yokyok
//
//  Created by Nazik on 11.02.2021.
//

import UIKit

class CategoriesVC: UIViewController {
    
    @IBOutlet weak var tabbarView: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var tabbarMainPageView: UIView!
    @IBOutlet weak var tabbarCategoriesView: UIView!
    @IBOutlet weak var tabbarMyFavouriteView: UIView!
    @IBOutlet weak var tabbarMyProfileView: UIView!
    
    var categoriesArray = [CategoriesDataResponse?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        setupLayouts()
        
        //MARK:- GESTURE RECOGNIZER
        addGestureRecognizer(view: tabbarMainPageView)
        addGestureRecognizer(view: tabbarMyFavouriteView)
        addGestureRecognizer(view: tabbarMyProfileView)
        
        getCategories()
    }
    
    
    func addGestureRecognizer(view: UIView) {
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gestureRecognizerMethods(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func gestureRecognizerMethods(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case tabbarMainPageView:
            let vc = self.storyboard?.instantiateViewController(identifier: "MainPageVC") as! MainPageVC
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
        tabbarView.backgroundColor = UIColor.white
        tabbarView.layer.borderColor = UIColor.lightGray.cgColor
        tabbarView.layer.borderWidth = 1
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
    
    
}

extension CategoriesVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCell
        cell.categoryNameLabel.text = categoriesArray[indexPath.row]?.title
        cell.categoryQuantityLabel.text = "\(String((categoriesArray[indexPath.row]?.count)!)) Ürün"
        cell.categoryImageView.sd_setImage(with: URL(string: BaseURL.CATEGORY_IMAGE_URL + "\(categoriesArray[indexPath.row]?.photo ?? "default.jpeg")"), completed: nil)
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: (UIScreen.main.bounds.width-30) / 2, height: (UIScreen.main.bounds.width-30) / 2)
        }
        
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CategoryDetailVC") as! CategoryDetailVC
        vc.category_id = categoriesArray[indexPath.row]?.id
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
