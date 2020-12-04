//
//  CompoundFutureViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-04.
//

import UIKit

class CompoundFutureViewController: UIViewController {
    
    var monthStart: Bool = true
    var calculatedFutureVal = "0.0"
    @IBOutlet weak var initialInvestment: UITextField!
    @IBOutlet weak var interestRate: UISlider!
    @IBOutlet weak var interestRateText: UITextField!
    @IBOutlet weak var monthlyPaymentAmount: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var paymentDoneAt: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func interestRateDidChange(_ sender: UISlider) {
        let interestRate = round(1000*sender.value)/1000
        self.interestRateText.text = "\(String(interestRate)) %"
    }
    
    @IBAction func interestRateTextDidChange(_ sender: UITextField) {
        let interestRateText = sender.text;
        let interestRateArr = interestRateText?.components(separatedBy: " ")
        let interestRateValue: Double = Double(interestRateArr![0]) ?? 0
        
        self.interestRate.value = Float(interestRateValue)
    }
    
    @IBAction func calculateFutureValue(_ sender: UIButton) {
        
        let initialInvestment = Double(self.initialInvestment.text!) ?? 0
        let monthlyPaymentAmount = Double(self.monthlyPaymentAmount.text!) ?? 0
        let duration = Int(self.duration.text!) ?? 0
        
        let calculatedFutureVal = Helper.calculateTotalFutureValue(initialInvestment, Double(interestRate.value), monthlyPaymentAmount, duration, 12, monthStart)
        self.calculatedFutureVal = calculatedFutureVal
        self.performSegue(withIdentifier: "goToTotalFutureValue", sender: self)
        
    }
    
    @IBAction func paymentDoneAtAction(_ sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
            case 0:
                monthStart = true
            case 1:
                monthStart = false
            default:
                break;
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
    
    // MARK: - Navigation to result modal

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       //Identify which segue was triggered if in future new segues are added to parent
       if segue.identifier == "goToTotalFutureValue" {
           //downcasting to a ModalViewController - destination is a UIViewController
           let destinationViewController = segue.destination as! ModalViewController
            let monthString = monthStart ? "(Payments at month Start)" : "(Payments at month End)"
           destinationViewController.headerName = "Total Future Value \(monthString)"
           destinationViewController.passedValue = calculatedFutureVal
       }
   }
    
}
