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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func interestRateChange(_ sender: UISlider) {
        let interestRate = round(1000*sender.value)/1000
        self.interestRateLabel.text = "\(String(interestRate)) %"
    }
    
    @IBAction func interestRateTextChange(_ sender: UITextField) {
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
        
        self.performSegue(withIdentifier: "goToOriginalAmount", sender: self)
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
   }
    

}
