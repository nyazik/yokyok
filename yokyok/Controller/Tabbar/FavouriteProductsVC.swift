//
//  FavouriteProductsVC.swift
//  yokyok
//
//  Created by Nazik on 11.02.2021.
//

import UIKit
import SDWebImage

class FavouriteProductsVC: UIViewController {
    
    
    @IBOutlet weak var favouriteProductsTableView: UITableView!
    @IBOutlet weak var tabbarView: UIView!
    
    @IBOutlet weak var tabbarMainPageView: UIView!
    @IBOutlet weak var tabbarCategoriesView: UIView!
    @IBOutlet weak var tabbarMyFavouriteView: UIView!
    @IBOutlet weak var tabbarMyProfileView: UIView!
    
    var favouritesArray = [FavouriteProductsDataResponse]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteProductsTableView.dataSource = self
        favouriteProductsTableView.delegate = self
        
        setupLayouts()
        
        //MARK:- GESTURE RECOGNIZER
        addGestureRecognizer(view: tabbarMainPageView)
        addGestureRecognizer(view: tabbarCategoriesView)
        addGestureRecognizer(view: tabbarMyProfileView)
        
        getFavourite()
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
        case tabbarCategoriesView:
            let vc = self.storyboard?.instantiateViewController(identifier: "CategoriesVC") as! CategoriesVC
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
        tabbarView.layer.borderWidth = 1
        tabbarView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func myCartTabbarButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "MyCartVC") as! MyCartVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    //MARK:- NETWORKING
    func getFavourite() {
        //addViewsForAnimation()
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "favorites")
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
                
                let favouritesResponse = try JSONDecoder().decode(FavouriteProductsResponse.self, from: data)

                if favouritesResponse.status{
                    DispatchQueue.main.async {
                        if favouritesResponse.data!.isEmpty == false {

                            self.favouritesArray = favouritesResponse.data!
                            print(self.favouritesArray)
                            self.favouriteProductsTableView.reloadData()

                        } else {
                            print("data yok")
                        }
//                        self.removeViewsForAnimation()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.removeViewsForAnimation()
                        let alert = UIAlertController(title: "Hata", message: favouritesResponse.message, preferredStyle: .alert)
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
    
    
    func deleteFavourite(id: Int) {
        
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "favorite/\(id)")
        
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        
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
                DispatchQueue.main.async {
                    if dataString.contains("true") {
                        print(dataString)
                    } else {
                        let alert = UIAlertController(title: "Hata", message: "Bir hata oluştu. Lütfen tekrar deneyiniz.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
}

extension FavouriteProductsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(favouritesArray.count)***")
        return favouritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!  FavouriteProductCell
        print("cell")
        cell.productPriceLabel.text = String(favouritesArray[indexPath.row].prices.price)
        cell.productDescriptionLabel.text = favouritesArray[indexPath.row].title
        cell.productCategoryLabel.text = favouritesArray[indexPath.row].categories
        cell.productImageView.sd_setImage(with: URL(string: BaseURL.PRODUCT_IMAGE_URL + "\(favouritesArray[indexPath.row].photo ?? "default.jpeg")"), completed: nil)
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            deleteFavourite(id: self.favouritesArray[indexPath.row].id!)
            self.favouritesArray.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        tableView.reloadData()
    }
    
    
}
