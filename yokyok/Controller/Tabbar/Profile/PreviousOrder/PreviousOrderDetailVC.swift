//
//  PreviousOrderDetailVC.swift
//  yokyok
//
//  Created by Nazik on 13.02.2021.
//

import UIKit

class PreviousOrderDetailVC: UIViewController {
    
    
    @IBOutlet var previousOrdersDetailTableView: UITableView!
    @IBOutlet weak var previousOrdersDetailTableViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousOrdersDetailTableView.dataSource = self
        previousOrdersDetailTableView.delegate = self
    }
    
    
    override func viewDidLayoutSubviews() {
        previousOrdersDetailTableViewHeightConstraint.constant = CGFloat.greatestFiniteMagnitude
        self.previousOrdersDetailTableView.reloadData()
        self.loadViewIfNeeded()
        previousOrdersDetailTableViewHeightConstraint.constant = self.previousOrdersDetailTableView.contentSize.height
    }
 
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension PreviousOrderDetailVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PreviousOrderDetailCell
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
