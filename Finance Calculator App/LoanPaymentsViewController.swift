//
//  LoanPaymentsViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-02.
//

import UIKit

class LoanPaymentsViewController: UIViewController {
    
    var calculatedNumberOfPayments = "0"
    
    @IBOutlet weak var interestRateLabel: UITextField!
    @IBOutlet weak var loanAmount: UITextField!
    @IBOutlet weak var paymentAmount: UITextField!
    @IBOutlet weak var interestRateSlider: UISlider!
    
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
    
    @IBAction func calculateButton(_ sender: Any) {
        let interestRate = interestRateSlider.value
        let loanAmount = Double(self.loanAmount.text!) ?? 0
        let paymentAmount = Double(self.paymentAmount.text!) ?? 0
        
        let numberOfPayments = Helper.calculateNumberOfPayments(paymentAmount, Double(interestRate), loanAmount)
        
        self.calculatedNumberOfPayments = numberOfPayments
        
        self.performSegue(withIdentifier: "goToNumberOfPayments", sender: self)
        
    }

    @IBAction func interestRateText(_ sender: UITextField) {
        let interestRateText = sender.text;
        let interestRateArr = interestRateText?.components(separatedBy: " ")
        let interestRateValue: Double = Double(interestRateArr![0]) ?? 0
        
        self.interestRateSlider.value = Float(interestRateValue)
    }
    
    @IBAction func viewAmotizationButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToTableViewNumPayments", sender: self)
    }
    
    // MARK: - Navigation to result modal

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Identify which segue was triggered if in future new segues are added to parent
        if segue.identifier == "goToNumberOfPayments" {
            //downcasting to a ModalViewController - destination is a UIViewController
            let destinationViewController = segue.destination as! ModalViewController
            destinationViewController.headerName = "NUMBER OF PAYMENTS"
            destinationViewController.passedValue = calculatedNumberOfPayments
        }
        
        if segue.identifier == "goToTableViewNumPayments" {
            let destinationViewController = segue.destination as! TableViewController

            let calculateYears = Int(calculatedNumberOfPayments) ?? 0
            let numberOfYears = Int(calculateYears/12)

            destinationViewController.interestRate = Double(self.interestRateSlider.value)
            destinationViewController.loanBalance = self.loanAmount.text ?? "0"
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
