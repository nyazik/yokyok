//
//  SuccessfulPaymentPopup.swift
//  yokyok
//
//  Created by Nazik on 14.02.2021.
//

import UIKit

class SuccessfulPaymentPopup: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sussessfulView: UIView!
    @IBOutlet weak var continueShoppingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        
        //MARK:- GESTURE RECOGNIZER
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchTapped(_:)))
        backgroundView.addGestureRecognizer(tap)
    }

    @objc func touchTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    func setupLayouts() {
        sussessfulView.layer.cornerRadius = 10
        sussessfulView.addShadow(color: .lightGray, opacity: 0.5, radius: 5)
        
        continueShoppingButton.layer.cornerRadius = continueShoppingButton.frame.height / 2
    }
   
    @IBAction func continueShoppingButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
}
