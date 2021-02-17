//
//  SignOutPopup.swift
//  yokyok
//
//  Created by Nazik on 15.02.2021.
//

import UIKit

class SignOutPopup: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
    }

    func setupLayouts() {
        signOutView.layer.cornerRadius = 10
//        cancelButton.roundCorners(corners: [.allCorners], radius: 10)
//        signOutView.roundCorners(corners: [.allCorners], radius: 10)
//        cancelButton.layer.cornerRadius = 10
//        signOutView.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        signOutButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
}
