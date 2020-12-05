//
//  Mortgage2ViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-04.
//

import UIKit

class MortgageViewController: UIViewController {
    @IBOutlet weak var homePrice: UITextField!
    @IBOutlet weak var interestRate: UISlider!
    @IBOutlet weak var numberOfYears: UITextField!
    @IBOutlet weak var interestRateText: UITextField!
    @IBOutlet weak var paymentAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        homePrice.addTarget(self, action: #selector(self.homePriceDidChange(_:)), for: .editingChanged)
        interestRate.addTarget(self, action: #selector(self.interestRateDidChange(_:)), for: .editingChanged)
        numberOfYears.addTarget(self, action: #selector(self.lengthOfLoanDidChange(_:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func homePriceDidChange(_ sender: UITextField) {
        let cal = calculateMortgage(Double(self.interestRate.value), self.numberOfYears.text!, homePrice.text!)
            self.paymentAmount.text = String(cal)
    }
    
    @IBAction func interestRateDidChange(_ sender: UISlider) {
        
        let interestRate = round(1000*sender.value)/1000
        self.interestRateText.text = "\(String(interestRate)) %"
        
        let cal = calculateMortgage(Double(self.interestRate.value), self.numberOfYears.text!, self.homePrice.text!)
            self.paymentAmount.text = String(cal)
    }
    
    @IBAction func lengthOfLoanDidChange(_ sender: UITextField) {
        let cal = calculateMortgage(Double(self.interestRate.value), self.numberOfYears.text!, self.homePrice.text!)
            self.paymentAmount.text = cal
    }
    @IBAction func interestRateTextChange(_ sender: UITextField) {
        let interestRateText = sender.text;
        let interestRateArr = interestRateText?.components(separatedBy: " ")
        let interestRateValue: Double = Double(interestRateArr![0]) ?? 0
        
        self.interestRate.value = Float(interestRateValue)
        
        let cal = calculateMortgage(Double(self.interestRate.value), self.numberOfYears.text!, self.homePrice.text!)
            self.paymentAmount.text = String(cal)
    }
    
    func calculateMortgage(_ interestRate: Double, _ numberOfYears: String, _ homePrice: String) -> String {
        
        //convert string values to numeric values
        let numberOfYearsInt:Int? = Int(numberOfYears) ?? 1
        let homePriceDouble:Double? = Double(homePrice) ?? 0
        
        return Helper.calculateMortgagePaymentAmount(interestRate, homePriceDouble!, numberOfYearsInt!)
    }
    
    @IBAction func openAmortizationTable(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToTableView", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Identify which segue was triggered if in future new segues are added to parent
        if segue.identifier == "goToTableView" {
            //downcasting to a ModalViewController - destination is a UIViewController
            let destinationViewController = segue.destination as! TableViewController
            destinationViewController.interestRate = Double(self.interestRate.value)
            destinationViewController.loanBalance = self.homePrice.text ?? "0"
            
            let paymentAmount = self.paymentAmount.text;
            let paymentAmountArr = paymentAmount?.components(separatedBy: " ")
            let paymentAmountValue: Double = Double(paymentAmountArr![1]) ?? 0
            
            destinationViewController.monthlyPayment = "\(paymentAmountValue)"
            destinationViewController.period = self.numberOfYears.text ?? "0"
        }
    }
}
