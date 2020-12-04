//
//  ViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 11/17/20.
//

import UIKit

class ViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var loanBtn: UIButton!
    @IBOutlet weak var savingsBtn: UIButton!
    @IBOutlet weak var mortgageBtn: UIButton!
    @IBOutlet weak var helpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loanBtnClicked(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func savingsBtnClicked(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    
    @IBAction func mortgageBtnClicked(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func helpBtnClicked(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
}

