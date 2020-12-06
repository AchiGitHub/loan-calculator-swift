//
//  InvestmentDurationViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-04.
//

import UIKit

class InvestmentDurationViewController: UIViewController {
    
    var calculatedDuration = "0"
    @IBOutlet weak var initialInvestment: UITextField!
    @IBOutlet weak var futureValue: UITextField!
    @IBOutlet weak var interestRate: UISlider!
    @IBOutlet weak var interestRateText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        view.addGestureRecognizer(tap)
    }    

    @IBAction func calculateDuration(_ sender: UIButton) {
        
        let initialInvestment = Double(self.initialInvestment.text!) ?? 0
        let futureValue = Double(self.futureValue.text!) ?? 0
        let interestRate = Double(self.interestRate.value)
        
        let calculateDuration = Helper.calculateDuration(futureValue, initialInvestment, interestRate, 12)
        
        self.calculatedDuration = calculateDuration
        
        self.performSegue(withIdentifier: "goToInvestmentDuration", sender: self)
    }
    
    @IBAction func interestRateTextChange(_ sender: UITextField) {
        let interestRateText = sender.text;
        let interestRateArr = interestRateText?.components(separatedBy: " ")
        let interestRateValue: Double = Double(interestRateArr![0]) ?? 0
        
        self.interestRate.value = Float(interestRateValue)
    }
    
    @IBAction func interestRateChange(_ sender: UISlider) {
        let interestRate = round(1000*sender.value)/1000
        self.interestRateText.text = "\(String(interestRate)) %"
    }
    
    // MARK: - Navigation to result modal

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       //Identify which segue was triggered if in future new segues are added to parent
       if segue.identifier == "goToInvestmentDuration" {
           //downcasting to a ModalViewController - destination is a UIViewController
           let destinationViewController = segue.destination as! SavingsModalViewController
           destinationViewController.headerName = "DURATION ON INVESTMENT"
           destinationViewController.passedValue = calculatedDuration
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
