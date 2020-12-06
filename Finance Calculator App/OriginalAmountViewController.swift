//
//  OriginalAmountViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-03.
//

import UIKit

class OriginalAmountViewController: UIViewController {
    
    var calculatedOriginalAmount = "0"
    
    @IBOutlet weak var paymentAmount: UITextField!
    @IBOutlet weak var interestRate: UISlider!
    @IBOutlet weak var numberOfPayments: UITextField!
    @IBOutlet weak var interestRateLabel: UITextField!
    @IBOutlet weak var viewPaymentsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func interestRateChange(_ sender: UISlider) {
        let interestRate = round(1000*sender.value)/1000
        self.interestRateLabel.text = "\(String(interestRate)) %"
    }
    
    @IBAction func interestRateDidChange(_ sender: UITextField) {
        let interestRateText = sender.text;
        let interestRateArr = interestRateText?.components(separatedBy: " ")
        let interestRateValue: Double = Double(interestRateArr![0]) ?? 0
        
        self.interestRate.value = Float(interestRateValue)
    }
    
    @IBAction func calculateOriginalAmount(_ sender: UIButton) {
        
        let paymentAmount = Double(self.paymentAmount.text!) ?? 0
        let numberOfPayments = Int(self.numberOfPayments.text!) ?? 0
        let interestRate = Double(self.interestRate.value)
        
        let calculateOriginalAmount = Helper.calculateInitialLoanAmount(paymentAmount, interestRate, numberOfPayments)
        
        self.calculatedOriginalAmount = calculateOriginalAmount
        
        viewPaymentsBtn.isEnabled = true
        
        self.performSegue(withIdentifier: "goToOriginalAmount", sender: self)
    }
    
    @IBAction func viewAmotizationButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToTableViewOnOriginalAmount", sender: self)
    }
    
    
    // MARK: - Navigation to result modal

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       //Identify which segue was triggered if in future new segues are added to parent
       if segue.identifier == "goToOriginalAmount" {
           //downcasting to a ModalViewController - destination is a UIViewController
           let destinationViewController = segue.destination as! ModalViewController
           destinationViewController.headerName = "ORIGINAL LOAN AMOUNT"
           destinationViewController.passedValue = calculatedOriginalAmount
       }
    if segue.identifier == "goToTableViewOnOriginalAmount" {
        let destinationViewController = segue.destination as! TableViewController
        
        let loanAmountText = calculatedOriginalAmount;
        let loanAmountArr = loanAmountText.components(separatedBy: " ")
        let loanAmountValue: Double = Double(loanAmountArr[1]) ?? 0
        
        let calculateYears = Int(self.numberOfPayments.text!) ?? 0
        let numberOfYears = Int(calculateYears/12)
        
        destinationViewController.interestRate = Double(self.interestRate.value)
        destinationViewController.loanBalance = String(loanAmountValue)
        destinationViewController.monthlyPayment = self.paymentAmount.text ?? "0"
        destinationViewController.period = String(numberOfYears)
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
