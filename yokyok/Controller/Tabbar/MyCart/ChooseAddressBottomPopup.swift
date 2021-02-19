//
//  ChooseAddressBottomPopup.swift
//  yokyok
//
//  Created by Nazik on 14.02.2021.
//

import UIKit
import BottomPopup

class ChooseAddressBottomPopup: BottomPopupViewController {
    @IBOutlet weak var savedAddressesTableView: UITableView!
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var addressTitle = ""
    var district = ""
    var address = ""
    
    var addressesArray = [AllAddressesDetailResponse]()
    var paymentScrenVC = PaymentScreenVC()
    
    override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedAddressesTableView.dataSource = self
        savedAddressesTableView.delegate = self
        
        getAddresses()
        
    }
    
   
    //MARK:- NETWORK
    
    @objc func getAddresses() {
        
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "address")
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
            
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print(dataString)
//            }
            
            guard let data = data else {return}
            
            do{
                
                let addressResponse = try JSONDecoder().decode(AllAddressesResponse.self, from: data)
                
                if addressResponse.status{
                    DispatchQueue.main.async {
                        if addressResponse.data?.addresses?.isEmpty == false {
                            self.addressesArray = (addressResponse.data?.addresses)!
                            print(self.addressesArray)
                            //self.myAddressedTableView.reloadData()
                            
                            self.savedAddressesTableView.reloadData()
                            
                            
                        } else {
                            print("data yok")
                        }
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        let alert = UIAlertController(title: "Hata", message: addressResponse.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            } catch let jsonError{
                print("Get address Response = \(jsonError)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    
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
extension ChooseAddressBottomPopup : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedAddressesCell
        cell.addressTitleLabel.text = addressesArray[indexPath.row].title
        addressTitle = addressesArray[indexPath.row].title!
        cell.districtLabel.text = addressesArray[indexPath.row].county_name
        district = addressesArray[indexPath.row].county_name!
        cell.addressLabel.text = addressesArray[indexPath.row].address
        address = addressesArray[indexPath.row].address!
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //dismiss(animated: true, completion: nil)
        print(addressesArray[indexPath.row].id)
//        NotificationCenter.default.post(name: .notificationA, object: nil)
        
        if let presenter = presentingViewController as? PaymentScreenVC {
//            presenter.sampleID = addressesArray[indexPath.row].id!
            presenter.getSpesificAddress(id: addressesArray[indexPath.row].id!)
        }
        
        dismiss(animated: true, completion: nil)
    }
}


