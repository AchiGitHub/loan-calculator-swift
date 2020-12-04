//
//  MortgageViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-11-29.
//

import UIKit

class MortgageViewController: UIViewController {

    @IBOutlet weak var homePrice: UITextField!
    @IBOutlet weak var interestRate: UITextField!
    @IBOutlet weak var numberOfYears: UITextField!
    @IBOutlet weak var monthlyPayment: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //automatic calculation of variables when fields change
        homePrice.addTarget(self, action: #selector(self.priceDidChange(_:)), for: .editingChanged)
        interestRate.addTarget(self, action: #selector(self.interestRateDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: Home price input change
    @IBAction func priceDidChange(_ homePrice: UITextField) {
        let cal = calculateMortgage(self.interestRate.text!, self.numberOfYears.text!, homePrice.text!)
            self.monthlyPayment.text = String(cal)
    }
    @IBAction func interestRateDidChange(_ interestRate: UITextField) {
        let cal = calculateMortgage(interestRate.text!, self.numberOfYears.text!, self.homePrice.text!)
            self.monthlyPayment.text = String(cal)
    }
    @IBAction func numberOfYearsDidChange(_ numberOfYears: UITextField) {
        let cal = calculateMortgage(self.interestRate.text!, numberOfYears.text!, self.homePrice.text!)
            self.monthlyPayment.text = cal
    }
    
    //MARK: Utility functions
    func calculateMortgage(_ interestRate: String, _ numberOfYears: String, _ homePrice: String) -> String {
        
        //convert string values to numeric values
        let numberOfYearsInt:Int? = Int(numberOfYears) ?? 1
        let interestRateDouble:Double? = Double(interestRate) ?? 0
        let homePriceDouble:Double? = Double(homePrice) ?? 0
        
        return Helper.calculateMortgagePaymentAmount(interestRateDouble!, homePriceDouble!, numberOfYearsInt!)
    }
}
