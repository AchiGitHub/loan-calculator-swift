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
    
     // MARK: - Navigation to result modal

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Identify which segue was triggered if in future new segues are added to parent
        if segue.identifier == "goToNumberOfPayments" {
            //downcasting to a ModalViewController - destination is a UIViewController
            let destinationViewController = segue.destination as! ModalViewController
            destinationViewController.headerName = "NUMBER OF PAYMENTS"
            destinationViewController.passedValue = calculatedNumberOfPayments
        }
    }
    
}
