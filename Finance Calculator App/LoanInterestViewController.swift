//
//  LoanInterestViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-03.
//

import UIKit

class LoanInterestViewController: UIViewController {
    
    var calculatedInterestRate = "0"
    
    @IBOutlet weak var loanAmount: UITextField!
    @IBOutlet weak var paymentAmount: UITextField!
    @IBOutlet weak var numberOfPayments: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func calculateInterestRate(_ sender: UIButton) {
        
        //convert text values to relevant type
        let loanAmount = Double(self.loanAmount.text ?? "0")
        let paymentAmount = Double(self.paymentAmount.text ?? "0")
        let numberOfPayments = Int(self.numberOfPayments.text ?? "0")
        
        let calculatedInterestRate = Helper.calculateInterestRate(paymentAmount!, loanAmount!, numberOfPayments!)
        
        self.calculatedInterestRate = calculatedInterestRate
        
        self.performSegue(withIdentifier: "goToInterestRate", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToInterestRate" {
            let destinationViewController = segue.destination as! ModalViewController
            
            destinationViewController.headerName = "INTEREST RATE"
            destinationViewController.passedValue = calculatedInterestRate
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}
