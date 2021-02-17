//
//  PaymentScreenVC.swift
//  yokyok
//
//  Created by Nazik on 14.02.2021.
//

import UIKit

class PaymentScreenVC: UIViewController {
    
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var districtLAbel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var minimumAmountLabel: UILabel!
    @IBOutlet weak var payAtTheDoorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(addressTitleLabel)
        setupLayouts()
        
        addGestureRecognizer(view: addressView)
    }
    
    func addGestureRecognizer(view: UIView) {
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gestureRecognizerMethods(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func gestureRecognizerMethods(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case addressView:
            let vc = self.storyboard?.instantiateViewController(identifier: "ChooseAddressBottomPopup") as! ChooseAddressBottomPopup
            vc.height = UIScreen.main.bounds.height / 2
            vc.dismissDuration = 3.0
            vc.presentDuration = 3.0
            vc.shouldDismissInteractivelty = true
            self.present(vc, animated: true, completion: nil)
            default:
            break
        }
    }
    
    func setupLayouts() {
        paymentView.layer.cornerRadius  = 10
        paymentView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        
        addressView.layer.cornerRadius = 10
        addressView.layer.backgroundColor = UIColor.white.cgColor
        addressView.layer.borderColor = UIColor.orange.cgColor
        addressView.layer.borderWidth = 1
        
        payButton.layer.cornerRadius = payButton.frame.height / 2
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payAtTheDoorButtonPressed(_ sender: UIButton) {
        
    }
    @IBAction func makePaymentButtonPressed(_ sender: UIButton) {
        let vc = SuccessfulPaymentPopup(nibName: "SuccessfulPaymentPopup", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
        
//        let vc = self.storyboard?.instantiateViewController(identifier: "ChooseAddressBottomPopup") as! ChooseAddressBottomPopup
//        vc.height = 300
//        vc.dismissDuration = 3.0
//        vc.presentDuration = 3.0
//        vc.shouldDismissInteractivelty = true
//        self.present(vc, animated: true, completion: nil)
    }
}
