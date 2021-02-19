//
//  MyAddressedVC.swift
//  yokyok
//
//  Created by Nazik on 12.02.2021.
//

import UIKit

class MyAddressedVC: UIViewController {
    
    @IBOutlet weak var addressedTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myAddressedTableView: UITableView!
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var myAddressedView: UIView!
    
    var addressesArray = [AllAddressesDetailResponse]()
    var defaultAddress = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
        getAddresses()
        
        myAddressedTableView.dataSource = self
        myAddressedTableView.delegate = self
    }
    
    func setupLayouts() {
        addAddressButton.layer.cornerRadius = addAddressButton.frame.height / 2
        myAddressedView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
    }
     
    override func viewDidLayoutSubviews() {
        addressedTableViewHeightConstraint.constant = CGFloat.greatestFiniteMagnitude
        self.myAddressedTableView.reloadData()
        self.loadViewIfNeeded()
        addressedTableViewHeightConstraint.constant = self.myAddressedTableView.contentSize.height
    }
    
    @IBAction func addAddressButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddEditAddressVC") as! AddEditAddressVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)    }
    
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
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
            
            guard let data = data else {return}
            
            do{
                
                let addressResponse = try JSONDecoder().decode(AllAddressesResponse.self, from: data)
                
                if addressResponse.status{
                    DispatchQueue.main.async {
                        if addressResponse.data?.addresses?.isEmpty == false {
                            self.addressesArray = (addressResponse.data?.addresses)!
                            print(self.addressesArray)
                            self.defaultAddress = (addressResponse.data?.default_id)!
                            print(self.defaultAddress)
                            self.myAddressedTableView.reloadData()
                            
                            self.defaultAddress = addressResponse.data!.default_id!

                            
                            for i in self.addressesArray {
                                if i.id! == self.defaultAddress {
                                    print("found")
                                    print("id: \(i.id!)")
                                    break
                                }
                            }
                            
                            self.addressedTableViewHeightConstraint.constant = CGFloat.greatestFiniteMagnitude
                            self.myAddressedTableView.reloadData()
                            self.myAddressedTableView.layoutIfNeeded()
                            self.addressedTableViewHeightConstraint.constant = self.myAddressedTableView.contentSize.height
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
    
    func deleteAddresses(id: Int) {
        
        let accessToken = UserDefaults.standard.string(forKey: "Autherization")!
        
        // Prepare URL
        let url = URL(string: BaseURL.baseURL + "address/\(id)")
        
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

extension MyAddressedVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyAddressCell
        //cell.select(defaultAddress)
        if addressesArray[indexPath.row].id == defaultAddress{
            cell.cellView.layer.borderColor = UIColor.orange.cgColor
            cell.cellView.layer.borderWidth = 1
            cell.cellView.layer.cornerRadius = 10
            cell.cellView.backgroundColor = .white
            cell.addressTitleLabel.text = addressesArray[indexPath.row].title
            cell.districtLabel.text = addressesArray[indexPath.row].county_name
            cell.addressLabel.text = addressesArray[indexPath.row].address
            
        } else {
            cell.addressTitleLabel.text = addressesArray[indexPath.row].title
            cell.districtLabel.text = addressesArray[indexPath.row].county_name
            cell.addressLabel.text = addressesArray[indexPath.row].address
            cell.configureCell()
        }
        
        
        return cell
    }
     
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddEditAddressVC") as! AddEditAddressVC
        vc.isNewAddress = false
        vc.districtName = addressesArray[indexPath.row].county_name!
        vc.addressID = addressesArray[indexPath.row].id!
        vc.addressTitle = addressesArray[indexPath.row].title!
        vc.address = addressesArray[indexPath.row].address!
        vc.districtId = addressesArray[indexPath.row].county!
        //vc.titleLabel.text = "Adres Güncelle"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            deleteAddresses(id: self.addressesArray[indexPath.row].id!)
            self.addressesArray.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        tableView.reloadData()
    }
    
    
}
