//
//  PaymentAmountViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-03.
//

import UIKit

class PaymentAmountViewController: UIViewController {
    var calculatedLoanAmount = "0"
    
    @IBOutlet weak var loanAmount: UITextField!
    @IBOutlet weak var interestRate: UISlider!
    @IBOutlet weak var numberOfPayments: UITextField!
    @IBOutlet weak var interestRateText: UITextField!
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
        self.interestRateText.text = "\(String(interestRate)) %"
    }
    
    @IBAction func interestRateTextDidChange(_ sender: UITextField) {
        let interestRateText = sender.text;
        let interestRateArr = interestRateText?.components(separatedBy: " ")
        let interestRateValue: Double = Double(interestRateArr![0]) ?? 0
        
        self.interestRate.value = Float(interestRateValue)
    }
    
    @IBAction func calculatePaymentAmount(_ sender: UIButton) {
        let interestRate = Double(self.interestRate.value)
        let loanAmount = Double(self.loanAmount.text!) ?? 0
        let numberOfPayments = Int(self.numberOfPayments.text!) ?? 0
        
        let paymentAmount = Helper.calculateLoanPaymentAmount(interestRate, loanAmount, numberOfPayments)
        
        self.calculatedLoanAmount = paymentAmount
        
        viewPaymentsBtn.isEnabled = true
        
        self.performSegue(withIdentifier: "goToPaymentAmount", sender: self)
    }
    
    @IBAction func viewAmortizationPayment(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToPaymentAmountTable", sender: self)
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
    
    
    // MARK: - Navigation to result modal

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       //Identify which segue was triggered if in future new segues are added to parent
       if segue.identifier == "goToPaymentAmount" {
           //downcasting to a ModalViewController - destination is a UIViewController
           let destinationViewController = segue.destination as! ModalViewController
           destinationViewController.headerName = "PAYMENT AMOUNT"
           destinationViewController.passedValue = calculatedLoanAmount
       }
    
        if segue.identifier == "goToPaymentAmountTable" {
            let destinationViewController = segue.destination as! TableViewController
            
            let calculatedLoanAmountText = calculatedLoanAmount;
            let calculatedLoanAmountArr = calculatedLoanAmountText.components(separatedBy: " ")
            
            let calculatedLoanAmountValue: Double = Double(calculatedLoanAmountArr[1]) ?? 0
            
            let calculateYears = Int(self.numberOfPayments.text!) ?? 0
            let numberOfYears = Int(calculateYears/12)
            
            destinationViewController.interestRate = Double(self.interestRate.value)
            destinationViewController.loanBalance = self.loanAmount.text ?? "0"
            destinationViewController.monthlyPayment = String(calculatedLoanAmountValue)
            destinationViewController.period = String(numberOfYears)
        }
   }

}
