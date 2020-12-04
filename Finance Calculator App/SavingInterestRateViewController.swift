//
//  SavingInterestRateViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-04.
//

import UIKit

class SavingInterestRateViewController: UIViewController {
    
    var calculatedInterestRate = "0.0"

    @IBOutlet weak var investmentAmount: UITextField!
    @IBOutlet weak var futureValue: UITextField!
    @IBOutlet weak var duration: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func calculateInterest(_ sender: UIButton) {
        //convert text values to relevant type
        let investmentAmount = Double(self.investmentAmount.text ?? "0")
        let futureValue = Double(self.futureValue.text ?? "0")
        let duration = Int(self.duration.text ?? "0")
        
        let calculatedInterestRate = Helper.calculateInterestRateForInvestment(futureValue!, investmentAmount!, 12, duration!)
        
        self.calculatedInterestRate = calculatedInterestRate
        
        self.performSegue(withIdentifier: "goToInvestmentInterest", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToInvestmentInterest" {
            let destinationViewController = segue.destination as! ModalViewController
            
            destinationViewController.headerName = "INTEREST RATE"
            destinationViewController.passedValue = calculatedInterestRate
        }
    }

}
